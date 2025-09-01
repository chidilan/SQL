-- ##########################################################
-- PART A: TRAINING SET INSIGHTS
-- ##########################################################

-- 1. How many passengers survived versus did not survive?
SELECT
    survived, 
    COUNT(*) AS total_passengers
FROM train
GROUP BY survived;

-- 2. What is the survival rate by gender?
SELECT
    sex,
    COUNT(*) AS total_passengers,
    SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) AS survivors,
    ROUND((SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS survival_rate
FROM train
GROUP BY sex;

-- 3. How does passenger class affect survival probability?
SELECT
    IsAlone,
    Survived,
    COUNT(*) AS total_passengers
FROM train
GROUP BY IsAlone, Survived
ORDER BY IsAlone, Survived;

-- 4. Does traveling with family impact survival rates?
SELECT
    FamilySize,
    ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM train
GROUP BY FamilySize;

-- 5. How does being alone versus with family affect survival?
SELECT
    IsAlone,
    ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM train
GROUP BY IsAlone;

-- 6. How does survival vary across age groups?
SELECT
    Age_group,
    ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM train
GROUP BY Age_group;

-- ##########################################################
-- PART B: TEST SET & BASELINE PREDICTIONS
-- ##########################################################

-- 1. Integrate Test Data with Gender-Based Predictions: Merge test data with gender_submission
SELECT
    t.PassengerId,
    t.sex,
    t.Pclass,
    gs.survived AS predicted_survival
FROM test t
JOIN gender_submission gs ON t.PassengerId = gs.PassengerId;

-- 2. Prediction Distribution: Overall predicted survival
SELECT
    survived,
    COUNT(*) AS total_predictions
FROM gender_submission
GROUP BY survived;

-- 3. How do predictions differ by gender?
SELECT
    t.sex,
    gs.survived,
    COUNT(*) AS total
FROM test t
JOIN gender_submission gs ON t.PassengerId = gs.PassengerId
GROUP BY t.sex, gs.survived
ORDER BY t.sex;

-- ##########################################################
-- PART C: COMBINED INSIGHTS & ADVANCED ANALYSIS
-- ##########################################################

-- 1. Which gender/class combination has highest survival rate?
SELECT
    sex,
    Pclass,
    COUNT(*) AS total,
    SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) AS survivors,
    ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM train
GROUP BY sex, Pclass
ORDER BY survival_rate DESC;

-- 2. Which ages show highest survival within each class?
SELECT
    age,
    Pclass,
    SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) AS total_survivors,
    ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate,
    RANK() OVER(PARTITION BY Pclass ORDER BY ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) DESC) AS survival_rank
FROM train
GROUP BY Pclass, age
ORDER BY Pclass, survival_rank;

-- 3. Youngest and Oldest Survivors Per Class
SELECT
    Pclass,
    MIN(age) AS youngest_survivor,
    MAX(age) AS oldest_survivor
FROM train
WHERE survived = 'Yes'
GROUP BY Pclass;

-- 4. Do passengers sharing tickets have higher survival?
SELECT
    ticket,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) AS total_survivors,
    ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM train
GROUP BY ticket
HAVING passenger_count > 1
ORDER BY survival_rate DESC;

-- 5. Average fare per person in ticket groups
SELECT
    ticket,
    ROUND(AVG(Fare), 2) AS avg_fare_per_person,
    COUNT(*) AS total_passengers
FROM train
GROUP BY ticket
HAVING total_passengers > 1
ORDER BY avg_fare_per_person DESC;

-- 6. Alone vs. With Family After Controlling for Class
SELECT
    Pclass,
    IsAlone,
    ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM train
GROUP BY Pclass, IsAlone
ORDER BY Pclass, IsAlone;

-- 7. Survival Probability by Fare Quartiles
WITH fare_quartiles AS (
    SELECT *,
           NTILE(4) OVER (ORDER BY Fare) AS fare_group
    FROM train
)
SELECT
    fare_group,
    ROUND(AVG(Fare), 2) AS avg_fare,
    ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM fare_quartiles
GROUP BY fare_group
ORDER BY fare_group;

-- 8. Baseline Gender Model Accuracy on Training Set
SELECT
    ROUND(100 * SUM(
        CASE 
            WHEN (sex = 'female' AND survived = 'Yes') OR (sex = 'male' AND survived = 'No')
            THEN 1 ELSE 0 
        END
    ) / COUNT(*), 2) AS gender_rule_accuracy
FROM train;

-- 9. Most Common Survivor Profile (Gender + Class + Embarked + Alone/With Family)
SELECT
    sex,
    Pclass,
    Embarked,
    IsAlone,
    COUNT(*) AS survivors
FROM train
WHERE survived = 'Yes'
GROUP BY sex, Pclass, Embarked, IsAlone
ORDER BY survivors DESC
LIMIT 1;

-- 10. How does survival probability change with age?
SELECT
    ROUND(age) AS age_bin,
    ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM train
WHERE age IS NOT NULL
GROUP BY ROUND(age)
ORDER BY age_bin;

-- 11. Average fare by class and survival
SELECT
    Pclass,
    ROUND(AVG(CASE WHEN survived = 'Yes' THEN fare END), 2) AS avg_fare_survivors,
    ROUND(AVG(CASE WHEN survived = 'No' THEN fare END), 2) AS avg_fare_non_survivors
FROM train
GROUP BY Pclass
ORDER BY Pclass;

-- 12. Family Survival Advantage Index
SELECT
    CASE WHEN (SibSp + Parch) > 0 THEN 'With Family' ELSE 'Alone' END AS family_status,
    ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM train
GROUP BY family_status;

-- 13. Ticket Sharing Advantage: Does sharing a ticket provide a survival advantage?
SELECT
    ticket_type,
    ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM (
    SELECT *,
        CASE WHEN COUNT(*) OVER (PARTITION BY ticket) > 1 THEN 'Shared Ticket' ELSE 'Solo Ticket' END AS ticket_type
    FROM train
) AS sub
GROUP BY ticket_type;

-- 14. High-Survival Feature Combinations: Gender + Alone/With Family
SELECT
    sex,
    IsAlone,
    ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM train
GROUP BY sex, IsAlone
ORDER BY survival_rate DESC;

-- 15. Average fare by class & survival
SELECT
    Pclass,
    ROUND(AVG(CASE WHEN survived = 'Yes' THEN fare END), 2) AS avg_fare_survivors,
    ROUND(AVG(CASE WHEN survived = 'No' THEN fare END), 2) AS avg_fare_non_survivors
FROM train
GROUP BY Pclass
ORDER BY Pclass;

-- 16. Survival rates by key categorical features
-- By Sex
SELECT sex,
       ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM train
GROUP BY sex;

-- By Pclass
SELECT Pclass,
       ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM train
GROUP BY Pclass;

-- By Embarked
SELECT Embarked,
       ROUND(100 * SUM(CASE WHEN survived = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS survival_rate
FROM train
GROUP BY Embarked;
