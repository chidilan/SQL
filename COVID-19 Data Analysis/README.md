# COVID-19 Global Analysis (SQL)
## __Table of Contents__ ##
<ul>

[1. About the project](#about-the-project)

[2. About the dataset](#about-the-dataset)

[3. Tools and libraries](#tools-and-libraries)

[4. Phases of the project](#phases-of-the-project)

<ul>

[4.1. Data Exploration](#1-data-exploration)

[4.2. Data Cleaning](#2-data-cleaning)

[4.3. Data Analysis and Visualization](#3-data-analysis-and-visualization)

</ul> </ul> <hr>

## __About the project__ ##

This project is a self-study analysis of COVID-19 global data.
The objective was to practice SQL for data exploration, transformation, and advanced analysis, while gaining insights into:

COVID-19 infection and death rates per country and continent

Vaccination coverage and trends

Daily, monthly, and yearly case/death growth

Identifying outliers and patterns across countries

<hr>

## __About the dataset__ ##

The dataset is sourced from global COVID-19 data: https://ourworldindata.org/covid-deaths

**<u>Key Tables and Columns Include:</u>**

covid_data

location → Country name

continent → Continent name

date → Date of report

total_cases → Cumulative confirmed cases

total_deaths → Cumulative deaths

new_cases → Daily new cases

new_deaths → Daily deaths

population → Population of country

people_vaccinated → People with at least one dose

gdp_data (optional join)

location → Country name

gdp_per_capita → GDP per person

<hr>

## __Tools and libraries__ ##

SQL → for cleaning, transformation, aggregation, and advanced queries

Optional visualization in Python or Tableau for dashboards:

Pandas for data manipulation

Matplotlib / Seaborn / Plotly for charts

<hr>

## __Phases of the project__ ##

### 1. Data Exploration ###

Initial checks included:

<ul>

Inspecting schema, columns, and datatypes

Checking date ranges and completeness of records

Summarizing cases, deaths, and vaccination coverage by country and continent

</ul> <hr>

### 2. Data Cleaning ###

Steps applied:
<ul>

Handle null values for cases, deaths, and population

Filter invalid records where population or cases were missing

Standardize country and continent names for consistency

Use of CTEs and temp tables for intermediate calculations

</ul> <hr>

### 3. Data Analysis and Visualization ###
<ul>

**<u>Key insights and SQL queries included:</u>**

1. Mortality Rate:
```sql
SELECT 
  location,
  ROUND(100.0 * total_deaths / total_cases, 2) AS death_rate_percentage
FROM covid_data
WHERE total_cases IS NOT NULL AND total_deaths IS NOT NULL
ORDER BY death_rate_percentage DESC;
```

> This query calculates the percentage of deaths in relation to the total number of cases. It helps us understand how severe the virus is in different locations and continents.

2. Percentage of Population Infected: 
```sql
SELECT 
  location,
  ROUND(100.0 * total_cases / population, 2) AS infection_rate
FROM covid_data
WHERE population IS NOT NULL AND total_cases IS NOT NULL
ORDER BY infection_rate DESC;
```

> This query determines the percentage of the population that has contracted COVID-19. By comparing the total number of cases to the population size, we can evaluate the spread of the virus in various regions.

3. Highest Infection Rate: 
```sql
SELECT 
  location,
  ROUND(100.0 * total_cases / population, 2) AS infection_rate
FROM covid_data
WHERE population IS NOT NULL AND total_cases IS NOT NULL
ORDER BY infection_rate DESC
LIMIT 10;
```

> This query identifies the country with the highest infection rate in proportion to its population. It calculates the percentage of the population that has been infected and highlights the location with the highest value.

4. Highest Death Rate: 


This query identifies the country with the highest death rate per population. It calculates the percentage of the population that has died due to COVID-19 and highlights the location with the highest mortality rate.

5. Country with the Highest Death Count: 

```sql
SELECT 
  location,
  ROUND(100.0 * total_deaths / population, 2) AS death_rate
FROM covid_data
WHERE total_deaths IS NOT NULL AND population IS NOT NULL
ORDER BY death_rate DESC
LIMIT 10;
```

> This query determines the country that has experienced the highest total number of deaths. It provides insights into the countries most impacted by the virus.

6. Continent with the Highest Death Count: 
```sql
SELECT 
  continent,
  ROUND(100.0 * SUM(total_deaths) / SUM(population), 2) AS continent_death_rate
FROM covid_data
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY continent_death_rate DESC;
```

> This query identifies the continent with the highest total number of deaths. It helps us understand the overall impact of the pandemic on a larger scale.

7. Global Cases per Day: 
```sql
SELECT 
  SUM(total_cases) AS global_cases,
  SUM(total_deaths) AS global_deaths,
  ROUND(100.0 * SUM(total_deaths) / SUM(total_cases), 2) AS global_death_rate
FROM covid_data
WHERE total_cases IS NOT NULL AND total_deaths IS NOT NULL;
```

This query presents the daily global COVID-19 cases, including the total number of new cases and new deaths. It also calculates the death rate as a percentage of new cases, giving us an indication of the severity of the virus over time.

8. Rolling Count of People Vaccinated: 
```sql
SELECT 
  location,
  ROUND(100.0 * people_vaccinated / population, 2) AS vaccination_rate
FROM covid_data
WHERE people_vaccinated IS NOT NULL AND population IS NOT NULL
ORDER BY vaccination_rate DESC;
```

This query calculates the cumulative count of vaccinated individuals on each day. It tracks the total number of people vaccinated and presents it alongside the population size. Additionally, it shows the percentage of the population that has received the vaccine.

</ul> <hr>

## __Project Highlights__ ##

* Extensive use of window functions (SUM() OVER, LAG(), RANK())

* Implementation of CTEs, temp tables, and views for modular queries

* Hierarchical aggregation using GROUPING SETS and ROLLUP

* Comparative analysis combining health data and GDP

* Some SQL techniques used in this project include joins, CTEs, temp tables, window functions, and aggregate functions to derive insights from the data. In addition to the SQL queries, this project involves creating views to store the results of our analyses. These views can be used for further exploration, data visualization, and reporting purposes.

* By analyzing the COVID-19 data using SQL, our project aims to provide meaningful insights into the impact of the virus on different regions, assess the effectiveness of vaccination efforts, and understand the severity of the pandemic over time. The findings from this project can contribute to informed decision-making, resource allocation, and the development of effective public health strategies.

