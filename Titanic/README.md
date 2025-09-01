# Titanic Survival Analysis (SQL)

## __Table of Contents__ ##
<ul>

[1. About the project](#about-the-project)

[2. About the dataset](#about-the-dataset)

[3. Tools and libraries](#tools-and-libraries)

[4. Phases of the project](#phases-of-the-project)

<ul>

  [4.1. Data Exploration](#1-data-exploration)

  [4.2. Data Cleaning](#2-data-cleaning)

  [4.3. Data Analysis and Insights](#3-data-analysis-and-insights)

</ul>

</ul>

<hr>

## __About the project__ ##
This project analyzes the Titanic passenger dataset to uncover survival patterns using SQL.  
The goal is to understand which factors influenced survival, including:  

- Gender, passenger class, and age  
- Family size and traveling alone  
- Ticket sharing and fare  
- Embarkation points  

<hr>

## __About the dataset__ ##
The dataset comes from the classic Titanic Kaggle challenge:  
> [Titanic - Machine Learning from Disaster](https://www.kaggle.com/c/titanic/data)

<u>
It contains information about passengers including:
</u>

* __PassengerId__  
* __Survived__ (Yes/No)  
* __Pclass__ (1st, 2nd, 3rd)  
* __Name__, __Sex__, __Age__  
* __SibSp__, __Parch__ (family members aboard)  
* __Ticket__, __Fare__, __Cabin__, __Embarked__  
* Derived features: `FamilySize`, `IsAlone`, `Age_group`  

<hr>

## __Tools and libraries__ ##
This project was done entirely using **SQL** (MySQL / SQL Server).  

* Aggregation, filtering, grouping, and ranking queries  
* Window functions (`ROW_NUMBER()`, `RANK()`, `NTILE()`)  
* Conditional expressions (`CASE WHEN`)  

<hr>

## __Phases of the project__ ##
### 1. Data Exploration ###
<ul>

Explored the dataset to answer key questions:  

1. Overall survival counts  
2. Survival rate by gender and passenger class  
3. Impact of family size and traveling alone  
4. Survival probability across age groups  

</ul>

<hr>

### 2. Data Cleaning ###
<ul>

Steps taken:  

1. Verified duplicates and missing values  
2. Created derived features:  
   - `FamilySize = SibSp + Parch`  
   - `IsAlone` (yes/no)  
   - `Age_group` (categorized ages)  
3. Standardized categorical values for consistent analysis  

</ul>

<hr>

### 3. Data Analysis and Insights ###
<ul>

<u>Key insights obtained from SQL queries:</u>

1. **Overall Survival**

   <img src="visuals/survival.png" alt="Survival Rate" width="500"/>

   > About 40% of passengers survived.  

2. **Gender Impact**

   <img src="visuals/GenderImpact.png" alt="Gender Impact" width="500"/>
   
   > Females had much higher survival rates than males.

3. **Passenger Class Impact**  

   <img src="visuals/PassengerClassImpact.png" alt="Passenger Class Impact" width="300"/>

   > 1st class had the highest survival, 3rd class the lowest.  

4. **Family & Traveling Alone**  
   
   <img src="visuals/Family&TravelingAlone.png" alt="Family Traveling Alone" width="300"/>
   
   > Passengers with family had slightly higher survival than those alone.  

5. **Age Effect**  
   
   <img src="visuals/AgeEffect.png" alt="Age Effect" width="300"/>

   > Children and younger adults had higher survival probabilities.

6. **Combined Features**  

   - **Highest Survival**  
   <img src="visuals/HighestSurvival.png" alt="Highest Survival" width="500"/>  
   > The Highest Survivors are Females in the 2nd class traveling with family

   - **Lowest Survival**  
   <img src="visuals/LowestSuvival.png" alt="Lowest Suvival" width="500"/>  
   > The Lowest Survivors are Males in the 2nd class traveling alone


7. **Ticket Sharing & Fare Analysis**

   - **Shared Tickets**  
   <img src="visuals/SharedTickets.png" alt="Shared Tickets" width="300"/>
   > Shared tickets showed higher survival than solo tickets

   - **Higher Fares**  
   <img src="visuals/FareQuartilesSurvival.png" alt="Fare Quartiles Survival" width="300"/>
   > Higher fares correlated with higher survival  

8. **Embarkation Points**

   <img src="visuals/Embarkation%20Points.png" alt="Embarkation Points" width="300"/>

   > Survival varied slightly by embarkation point (C > Q > S)  

9. **Baseline Gender Model**

   <img src="visuals/Usinggenderalone.png" alt="Gender Alone" width="300"/>

   > Using gender alone as a rule yields ~76% accuracy on training set  

10. **Advanced Insights**

   - **Survival probability by fare quartiles, age bins, and class**

   1. **Fare Quality**  
   <img src="visuals/FareQuartilesSurvival.png" alt="Fare Quartiles Survival" width="300"/>

   2. **Age Bins**  
   <img src="visuals/SurvivalprobabilitybyAge.png" alt="Survival Probability by Age" width="500"/>


   3. **Class**  
   <img src="visuals/SurvivalProbabilityByClass.png" alt="Survival Probability By Class" width="300"/>


   - **Most common survivor profile: female, 2nd class, embarked at S, with family**

      <img src="visuals/Mostcommonsurvivorprofile.png" alt="Most common Survivor Profile" width="500"/>

</ul>

<hr>