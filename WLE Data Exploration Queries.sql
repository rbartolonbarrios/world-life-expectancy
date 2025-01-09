# World Life Expectancy Project (Exploratory Data Analysis)

SELECT *
FROM world_life_expectancy;

-- Minimum and maximum life expectancy for each country
SELECT Country, MIN(`Life expectancy`), MAX(`Life expectancy`)
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0 
AND MAX(`Life expectancy`) <> 0
ORDER BY Country DESC
;

-- Adding a new column 'Life_Increase_15_Years' to determine the difference in minimum and maximum life expectancy
-- We can now determine which countries have had the most significant change in life expectancy
SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`), 1) AS Life_Increase_15_Years
#life increase over 15 years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0 
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years ASC
;


-- Average life expectancy every year (across all countries)
SELECT Year, ROUND(AVG(`Life expectancy`), 2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0 
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

-- Comparing average life expectancy with average GDP for each country
SELECT Country, ROUND(AVG(`Life expectancy`), 1) AS Life_Exp, ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP
;

-- Comparing overall GDP and Life expectancy of countries with High GDP vs Low GDP
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END ) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) AS High_GDP_Life_Expectancy,
#Second column gives us the life expectancy of all rows from first column. 1326 to be exact
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END ) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) AS Low_GDP_Life_Expectancy
FROM world_life_expectancy
;


-- Status vs Average Life Expectancy
SELECT Status, ROUND(AVG(`Life expectancy`), 2)
FROM world_life_expectancy
GROUP BY Status
;

-- Including a count column to the prior query
SELECT Status, COUNT(DISTINCT Country),
ROUND(AVG(`Life expectancy`), 2)
FROM world_life_expectancy
GROUP BY Status
;

-- Average Life Expectancy vs Average BMI
-- Not much correlation, it appears
SELECT Country, ROUND(AVG(`Life expectancy`), 1) AS Life_Exp, ROUND(AVG(BMI), 1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC
;

-- Adult mortality, including a rolling total
SELECT Country, 
Year, 
`Life expectancy`,
`Adult Mortality`, 
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;
