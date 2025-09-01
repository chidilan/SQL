-- ===========================================
-- 1. Drop staging table if it exists
-- ===========================================
DROP TABLE IF EXISTS layoffs2;
DROP TABLE IF EXISTS layoffs_staging;

-- ===========================================
-- 2. Create staging table from original layoffs
-- ===========================================
CREATE TABLE layoffs_staging LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- ===========================================
-- 3. Remove duplicates while creating clean table
-- ===========================================
CREATE TABLE layoffs2 AS
WITH dup AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off,
                            percentage_laid_off, date, stage, country, funds_raised
           ) AS row_num
    FROM layoffs_staging
)
SELECT company,
       location,
       industry,
       total_laid_off,
       percentage_laid_off,
       date,
       stage,
       country,
       funds_raised
FROM dup
WHERE row_num = 1;

-- ===========================================
-- 4. Standardize company names
-- ===========================================
UPDATE layoffs2
SET company = TRIM(company);

-- ===========================================
-- 5. Standardize industry names
-- ===========================================
UPDATE layoffs2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- ===========================================
-- 6. Standardize country names
-- ===========================================
UPDATE layoffs2
SET country = 'United States'
WHERE country LIKE 'United States%';

-- ===========================================
-- 7. Clean date column
-- ===========================================

-- a) Remove numeric garbage
UPDATE layoffs2
SET `date` = NULL
WHERE `date` REGEXP '^[0-9]+\\.[0-9]+$';

-- b) Trim spaces
UPDATE layoffs2
SET `date` = TRIM(`date`);

-- c) Convert valid MM/DD/YYYY strings to DATE
UPDATE layoffs2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
WHERE `date` LIKE '%/%/%';

-- d) Alter column to proper DATE type
ALTER TABLE layoffs2
MODIFY COLUMN `date` DATE;

-- ===========================================
-- 8. Normalize industry column
-- ===========================================

-- a) Convert empty strings to NULL
UPDATE layoffs2
SET industry = NULL
WHERE industry = '';

-- b) Fill missing industry values from other rows with same company
UPDATE layoffs2 t1
JOIN layoffs2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- ===========================================
-- 9. Check rows with missing layoffs data
-- ===========================================
SELECT *
FROM layoffs2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- ===========================================
-- 10. Final cleanup done, show clean table
-- ===========================================
SELECT *
FROM layoffs2
ORDER BY company;