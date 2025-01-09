
# World Life Expectancy Project (Data Cleaning Queries)

SELECT * 
FROM world_life_expectancy
;


-- Identifying duplicates by creating a unique identifier for each row

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;


-- Identifying Row_ID for duplicates found
SELECT *
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, 	Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
    ) AS Row_table
WHERE Row_Num > 1
;

-- Deleting duplicates
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
    ) AS Row_table
WHERE Row_Num > 1
)
;

-- Identifying blank values in Status column
SELECT * 
FROM world_life_expectancy
WHERE Status = ''
;

-- Determining all unique possible values for Status column
SELECT DISTINCT (Status) 
FROM world_life_expectancy
WHERE Status <> ''
;

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;


-- Updating status for 'Developing' countries to match existing status value from related rows
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

-- We identify the same issue as above for the 'Developed' countries 
SELECT * 
FROM world_life_expectancy
WHERE Country = 'United States of America'
;

-- Updating status for 'Developed' countries to match existing status value from related rows
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

-- We discover missing values under 'life expecatancy' column
SELECT * 
FROM world_life_expectancy
#WHERE `Life expectancy` = ''
;

-- Filling in missing values using data imputation, in particular, the average of the year before and after
SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy`+ t3.`Life expectancy`)/2, 1) AS average_life
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
	AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
	AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

-- Updating missing 'Life expecting' values by executing data imputation
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
	AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
	AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy`+ t3.`Life expectancy`)/2, 1)
WHERE t1.`Life expectancy` = ''
;


