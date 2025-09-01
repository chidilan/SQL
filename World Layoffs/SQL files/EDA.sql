-- EDA

-- Here we are jsut going to explore the data and find trends or patterns or anything interesting like outliers

USE `World Layoffs`;
-- ========================================
-- 1. Inspecting staging table
-- ========================================
SELECT *
from layoffs_staging;

-- ========================================
-- 2. Inspect cleaned layoffs table
-- ========================================
SELECT * 
FROM layoffs2;

-- ========================================
-- 3. Basic Statistics
-- ========================================

-- a) Largest single layoffs on one day
SELECT MAX(total_laid_off) AS max_single_layoff
FROM layoffs2;

-- b) Looking at Percentage to see how big these layoffs were
SELECT 	MAX(percentage_laid_off) AS max_pct_laid_off,
		MIN(percentage_laid_off) AS min_pct_laid_off
FROM layoffs2
WHERE  percentage_laid_off IS NOT NULL;

-- c) Companies that laid off 100% of employees
SELECT *
FROM layoffs2
WHERE  percentage_laid_off = 100
ORDER BY funds_raised DESC;

-- ========================================
-- 4. Companies with biggest Layoffs
-- ========================================

-- a) Biggest single Layoff event
SELECT company, total_laid_off
FROM layoffs2
ORDER BY total_laid_off DESC
LIMIT 5;
-- now that's just on a single day

-- b) Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;


-- ========================================
-- 5. Layoffs by Geography(location)
-- ========================================

-- a) by location
SELECT location, SUM(total_laid_off) AS total_laid_off
FROM layoffs2
GROUP BY location
ORDER BY total_laid_off DESC
LIMIT 10;
-- this it total in the past 3 years or in the dataset

-- b) by country
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs2
GROUP BY country
ORDER BY total_laid_off DESC;

-- ===========================================
-- 6. Layoffs over time
-- ===========================================

-- Total layoffs by year
SELECT YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs2
GROUP BY year
ORDER BY year ASC;

-- Rolling total layoffs per month
WITH monthly_layoffs AS (
    SELECT DATE_FORMAT(date, '%Y-%m') AS month, SUM(total_laid_off) AS total_laid_off
    FROM layoffs2
    GROUP BY month
)
SELECT month,
       SUM(total_laid_off) OVER (ORDER BY month ASC) AS rolling_total_layoffs
FROM monthly_layoffs
ORDER BY month ASC;

-- ===========================================
-- 7. Layoffs by industry and stage
-- ===========================================

-- By industry
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM layoffs2
GROUP BY industry
ORDER BY total_laid_off DESC;

-- By stage
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM layoffs2
GROUP BY stage
ORDER BY total_laid_off DESC;

-- ===========================================
-- 8. Top companies per year
-- ===========================================

WITH company_year AS (
    SELECT company, YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off
    FROM layoffs2
    GROUP BY company, year
),
company_year_rank AS (
    SELECT company, year, total_laid_off,
           DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS rank_in_year
    FROM company_year
)
SELECT company, year, total_laid_off, rank_in_year
FROM company_year_rank
WHERE rank_in_year <= 3
ORDER BY year ASC, total_laid_off DESC;