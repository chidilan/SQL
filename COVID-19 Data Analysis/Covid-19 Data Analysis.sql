-- 1. likelihood of dying if you contract covid in your country
-- 2. What percentage of population infected with covid
-- 3. countries with higest infection rate compared to population
-- 4. Countries with highest death count per population

-- PART TWO
-- 6. Contintents with highest death count per population
-- 7. GLobal numbers
-- 8. Percentage of population that has recieved at least one covid vaccine
-- 9. Percentage of population that has recieved at least one covid vaccine (Use CTE this time)
-- 10. Using Temp Table to perform calculation on Partition By in previous query
-- 11. Creating View to store data for later visualizatons


-- ANSWERS

-- 1. Likelihood of dying if you contract covid in your country
SELECT 
  location,
  ROUND(100.0 * total_deaths / total_cases, 2) AS death_rate_percentage
FROM covid_data
WHERE total_cases IS NOT NULL AND total_deaths IS NOT NULL
ORDER BY death_rate_percentage DESC;

-- 2. What percentage of population infected with covid
SELECT 
  location,
  ROUND(100.0 * total_cases / population, 2) AS infection_rate
FROM covid_data
WHERE population IS NOT NULL AND total_cases IS NOT NULL
ORDER BY infection_rate DESC;

-- 3. Countries with highest infection rate compared to population
-- (Same as #2, limit to top 10)
SELECT 
  location,
  ROUND(100.0 * total_cases / population, 2) AS infection_rate
FROM covid_data
WHERE population IS NOT NULL AND total_cases IS NOT NULL
ORDER BY infection_rate DESC
LIMIT 10;

-- 4. Countries with highest death count per population
SELECT 
  location,
  ROUND(100.0 * total_deaths / population, 2) AS death_rate
FROM covid_data
WHERE total_deaths IS NOT NULL AND population IS NOT NULL
ORDER BY death_rate DESC
LIMIT 10;

-- 5. Continents with highest death count per population
SELECT 
  continent,
  ROUND(100.0 * SUM(total_deaths) / SUM(population), 2) AS continent_death_rate
FROM covid_data
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY continent_death_rate DESC;

-- 6. Global numbers
SELECT 
  SUM(total_cases) AS global_cases,
  SUM(total_deaths) AS global_deaths,
  ROUND(100.0 * SUM(total_deaths) / SUM(total_cases), 2) AS global_death_rate
FROM covid_data
WHERE total_cases IS NOT NULL AND total_deaths IS NOT NULL;

-- 7. Percentage of population that has received at least one covid vaccine
SELECT 
  location,
  ROUND(100.0 * people_vaccinated / population, 2) AS vaccination_rate
FROM covid_data
WHERE people_vaccinated IS NOT NULL AND population IS NOT NULL
ORDER BY vaccination_rate DESC;

-- 8. Using CTE for vaccination rate
WITH vacc AS (
  SELECT location, people_vaccinated, population
  FROM covid_data
  WHERE people_vaccinated IS NOT NULL AND population IS NOT NULL
)
SELECT 
  location,
  ROUND(100.0 * people_vaccinated / population, 2) AS vaccination_rate
FROM vacc
ORDER BY vaccination_rate DESC;

-- 9. Using temp table to calculate case growth per country
CREATE TEMPORARY TABLE case_growth AS
SELECT 
  location,
  date,
  new_cases,
  SUM(new_cases) OVER (PARTITION BY location ORDER BY date) AS cumulative_cases
FROM covid_data;

-- 10. Top 10 countries with fastest daily growth
SELECT 
  location,
  date,
  new_cases,
  LAG(new_cases) OVER (PARTITION BY location ORDER BY date) AS previous_day,
  new_cases - LAG(new_cases) OVER (PARTITION BY location ORDER BY date) AS growth
FROM covid_data
WHERE new_cases IS NOT NULL
ORDER BY growth DESC
LIMIT 10;

-- 11. 7-day rolling average of new cases
SELECT 
  location,
  date,
  ROUND(AVG(new_cases) OVER (PARTITION BY location ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS rolling_avg_7d
FROM covid_data
WHERE new_cases IS NOT NULL;

-- 12. Compare death rates before/after Jan 1, 2021
SELECT 
  location,
  CASE WHEN date < '2021-01-01' THEN 'Before' ELSE 'After' END AS period,
  ROUND(100.0 * SUM(new_deaths) / SUM(new_cases), 2) AS death_rate
FROM covid_data
WHERE new_cases IS NOT NULL AND new_deaths IS NOT NULL
GROUP BY location, period;

-- 13. Rank countries by vaccination rate within continent
SELECT 
  continent,
  location,
  ROUND(100.0 * people_vaccinated / population, 2) AS vaccination_rate,
  RANK() OVER (PARTITION BY continent ORDER BY people_vaccinated / population DESC) AS rank_in_continent
FROM covid_data
WHERE continent IS NOT NULL AND people_vaccinated IS NOT NULL;

-- 14. Median death rate per continent (using percentile in supported DBs)
WITH ranked AS (
  SELECT 
    continent,
    (total_deaths / population) AS death_rate,
    ROW_NUMBER() OVER (PARTITION BY continent ORDER BY total_deaths / population) AS rn,
    COUNT(*) OVER (PARTITION BY continent) AS cnt
  FROM covid_data
  WHERE continent IS NOT NULL
)
SELECT 
  continent,
  AVG(death_rate) AS median_death_rate
FROM ranked
WHERE rn IN (FLOOR((cnt + 1) / 2), CEIL((cnt + 1) / 2))
GROUP BY continent;

-- 15. High vaccination but rising infection
WITH daily AS (
  SELECT 
    location,
    date,
    people_vaccinated,
    population,
    new_cases,
    ROUND(100.0 * people_vaccinated / population, 2) AS vacc_rate,
    LAG(new_cases) OVER (PARTITION BY location ORDER BY date) AS prev_cases
  FROM covid_data
  WHERE population IS NOT NULL AND people_vaccinated IS NOT NULL
)
SELECT *
FROM daily
WHERE vacc_rate > 70 AND new_cases > prev_cases
ORDER BY location, date;


-- 16. GROUPING SETS for country + continent summaries
SELECT 
    continent,
    location,
    SUM(total_cases) AS total_cases,
    SUM(total_deaths) AS total_deaths
FROM covid_data
GROUP BY continent, location WITH ROLLUP
HAVING (continent IS NOT NULL AND location IS NOT NULL)
    OR (continent IS NOT NULL AND location IS NULL);


-- 17. ROLLUP for hierarchical summaries
SELECT 
  continent, location,
  SUM(total_cases) AS total_cases,
  SUM(total_deaths) AS total_deaths
FROM covid_data
GROUP BY ROLLUP (continent, location);

-- 18. Determine cumulative COVID-19 cases per country, day by day.
SELECT
    location,
    date,
    new_cases,
    SUM(new_cases) OVER (PARTITION BY location ORDER BY date) AS cumulative_cases
FROM covid_data
ORDER BY location, date;

-- 19. Outlier countries by fatality rate
SELECT 
  location,
  ROUND(100.0 * total_deaths / total_cases, 2) AS fatality_rate
FROM covid_data
WHERE total_cases > 100000
ORDER BY fatality_rate DESC;

-- 20. Pandemic wave peaks (e.g., max new_cases by month)
SELECT 
  location,
  DATE_FORMAT(date, '%Y-%m') AS month,   -- '2021-07'
  MAX(new_cases) AS peak_cases           -- highest single-day count in that month
FROM covid_data
GROUP BY location, DATE_FORMAT(date, '%Y-%m')
ORDER BY location, month;

-- 21. Highest death month per country

SELECT
	m.location,
    m.month,
    m.deaths
FROM (
  SELECT 
	location, 
	DATE_FORMAT(date, '%Y-%m') AS month, 
	SUM(new_deaths) AS deaths
  FROM covid_data
  GROUP BY location, DATE_FORMAT(date, '%Y-%m')
) m
JOIN (
  SELECT 
	location, 
    MAX(total) AS max_deaths
  FROM (
    SELECT 
		location, 
        DATE_FORMAT(date, '%Y-%m') AS month, 
        SUM(new_deaths) AS total
    FROM covid_data
    GROUP BY 
		location, 
        DATE_FORMAT(date, '%Y-%m')
  ) t
  GROUP BY location
) x
ON m.location = x.location AND m.deaths = x.max_deaths;


-- 22. Year-over-year change in deaths
SELECT 
  location,
  EXTRACT(YEAR FROM date) AS year,
  SUM(new_deaths) AS yearly_deaths,
  LAG(SUM(new_deaths)) OVER (PARTITION BY location ORDER BY EXTRACT(YEAR FROM date)) AS previous_year,
  SUM(new_deaths) - LAG(SUM(new_deaths)) OVER (PARTITION BY location ORDER BY EXTRACT(YEAR FROM date)) AS `change`
FROM covid_data
GROUP BY location, year;