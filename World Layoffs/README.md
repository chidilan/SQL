# World-Layoffs-Analysis (SQL + Python)

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

</ul>

</ul>

<hr>

## __About the project__ ##
This is a self-study project where I analyzed global layoff data from 2020 to 2023.  
The objective was to practice SQL and Python for data cleaning, analysis, and visualization, while gaining insights into:  

- Which industries were most affected  
- Which countries and companies had the highest layoffs  
- Trends across years and business stages  

<hr>

## __About the dataset__ ##
The dataset is open-source from __Kaggle__:  
> [Layoffs 2022 Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

<u>
The dataset contains one CSV file with company layoff records. Key columns include:
</u>

* __Company__: The company name  
* __Location__: The city/region of layoffs  
* __Industry__: Sector of the company  
* __Total laid off__: Number of employees laid off  
* __Percentage laid off__: Percentage of workforce laid off  
* __Date__: When layoffs happened  
* __Stage__: Company stage (Startup, Post-IPO, etc.)  
* __Country__: Country where layoffs occurred  
* __Funds raised (millions)__: Reported funds raised  

<hr>

## __Tools and libraries__ ##
The project was done in both SQL and Python.  

* __SQL (MySQL/SQL Server)__ → cleaning, transformations, aggregation queries  
* __Python__ → for queries, analysis, and visualization  
  * Pandas, SQLAlchemy → SQL integration & data manipulation  
  * Matplotlib, Seaborn → visualizations  
  * Plotly → interactive charts  

<hr>

## __Phases of the project__ ##
### 1. Data Exploration ###
<ul>

Initial checks included:  

1. Dataset size and schema  
2. Columns and datatypes  
3. Date range (2020 → 2023)  
4. Distribution of layoffs across industries and countries  

</ul>

<hr>

### 2. Data Cleaning ###
<ul>

The following steps were applied:  

1. **Remove duplicates** using `ROW_NUMBER()` in SQL  
2. **Standardize values**:  
   - Consolidated industry names (e.g. “Crypto”, “Cryptocurrency” → __Crypto__)  
   - Fixed inconsistent country names (“United States” vs “United States.”)  
   - Converted `date` from text → date type  
3. **Handle nulls**: filled missing industry values using self-joins  
4. **Remove unwanted rows** where both layoffs and percentages were null  

</ul>

<hr>

### 3. Data Analysis and Visualization ###
<ul>

<u>Key insights and charts include:</u>

1. **Layoffs by Country**  
<img src="visuals/layoffs_pie_chart.png" alt="Layoffs by Country" width="500"/>  
> The United States had the highest layoffs overall.

2. **Layoffs by Year**  
<img src="visuals/TotalLayoffsPerYear.png" alt="Layoffs by Year" width="500"/>  
> 2024 recorded the highest layoffs across industries.

3. **Layoffs by Industry**  
<img src="visuals/IndustryLayoffs.png" alt="Layoffs by Industry" width="500"/>  
> The Hardware sector was hit hardest.

4. **Layoffs by Business Stage**  
<img src="visuals/LayoffsByCompanyStage.png" alt="Layoffs by Stage" width="500"/>  
> Post-IPO companies drove the largest layoffs.

5. **Top Companies per Year (Python + SQL)**  
<img src="visuals/TopCompanyLayoffs.png" alt="Top Companies per Year" width="500"/>  
> Companies like Intel, Microsoft, Tesla and Cisco had the biggest layoffs in different years.

6. **Timeline of Layoffs (Monthly)**  
<img src="visuals/CumulativeLayoffsOverTime.png" alt="Timeline of Layoffs" width="500"/>  

</ul>

<hr>
