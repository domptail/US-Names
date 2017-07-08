USE USNamesDB
GO

**************************************
--Show the trend of the name Kim over the years
SELECT 
		USName,
		USGender,
		USNumber,
		USYear
FROM 
		USNamesTable
WHERE
		USName = 'Kim'
ORDER BY
		USYear

**************************************
--Total number of births per year
SELECT
		USYear,
		SUM(USNumber) AS TotalAnnualBirths
FROM
		USNamesTable
GROUP BY
		USYear
ORDER BY
		USYear
		
**************************************
--Top 10 most popular male first names overall in terms of absolute numbers
SELECT TOP 10
		USName AS TopMaleName,
		FORMAT(SUM(USNumber), '###,###,###') AS TotalAnnualBirths
FROM
		USNamesTable
WHERE
		USGender = 'M'
GROUP BY
		USName
ORDER BY
		SUM(USNumber) DESC

--Top 10 most popular female first names overall in terms of absolute numbers
SELECT TOP 10
		USName AS TopFemaleName,
		FORMAT(SUM(USNumber), '###,###,###') AS TotalAnnualBirths
FROM
		USNamesTable
WHERE
		USGender = 'F'
GROUP BY
		USName
ORDER BY
		SUM(USNumber) DESC

**************************************
--Top 10 most popular male first names in 2015
SELECT TOP 10
		USName AS TopMaleName,
		USYear,
		FORMAT(SUM(USNumber), '###,###,###') AS TotalAnnualBirths
FROM
		USNamesTable
WHERE
		USGender = 'M'
AND
		USYear = 2015
GROUP BY
		USName,
		USYear
ORDER BY
		SUM(USNumber) DESC

--Top 10 most popular female first names in 2015
SELECT TOP 10
		USName AS TopMaleName,
		USYear,
		FORMAT(SUM(USNumber), '###,###,###') AS TotalAnnualBirths
FROM
		USNamesTable
WHERE
		USGender = 'F'
AND
		USYear = 2015
GROUP BY
		USName,
		USYear
ORDER BY
		SUM(USNumber) DESC

**************************************
--Identifying the most gender neutral names with at least 1,000 people in total
WITH 
CTE_Female (FemaleName, FemaleNumber)
AS
(
SELECT
		USName,
		SUM(USNumber)
FROM
		USNamesTable
WHERE
		USGender = 'F'
GROUP BY
		USName
),
CTE_Male (MaleName, MaleNumber)
AS
(
SELECT
		USName,
		SUM(USNumber)
FROM
		USNamesTable
WHERE
		USGender = 'M'
GROUP BY
		USName
)
SELECT
		F.FemaleName AS GenderNeutralName,
		F.FemaleNumber,
		M.MaleNumber,
		(F.FemaleNumber + M.MaleNumber) AS TotalNumber, 
		(CAST(100.0 * F.FemaleNumber / (F.FemaleNumber + M.MaleNumber) AS NUMERIC(5,1))) AS FemalePercent,
		(CAST(100.0 * M.MaleNumber / (F.FemaleNumber + M.MaleNumber) AS NUMERIC(5,1))) AS MalePercent,
		(CAST(ABS(50.0 - (100.0 * F.FemaleNumber / (F.FemaleNumber + M.MaleNumber))) AS NUMERIC(5,1))) AS PercentAwayFrom50
FROM 
		CTE_Female AS F
INNER JOIN
		CTE_Male AS M
ON
		F.FemaleName = M.MaleName
WHERE
		F.FemaleNumber > 500
AND
		M.MaleNumber > 500
AND
		F.FemaleName <> 'Unknown'
AND
		ABS(50.0 - (100.0 * F.FemaleNumber / (F.FemaleNumber + M.MaleNumber))) < 25
ORDER BY
		ABS(50.0 - (100.0 * F.FemaleNumber / (F.FemaleNumber + M.MaleNumber))),
		(F.FemaleNumber + M.MaleNumber) DESC
		
**************************************		
--Identifying 'new' female names (names that did not exist before year 2010 with at least 100 people in total)
SELECT
		a.USName AS FemaleYear,
		a.MinYear AS FirstYear,
		a.TotalNumber
FROM
		(SELECT 
				USName,
				MIN(USYear) AS MinYear,
				MAX(USYear) AS MaxYear,
				SUM(USNumber) AS TotalNumber
		FROM 
				USNamesTable
		WHERE
				USGender = 'F'
		GROUP BY
				USName)
		AS a
WHERE
		a.MinYear > 2010
AND
		a.TotalNumber > 100
ORDER BY
		a.TotalNumber DESC

**************************************		
--Identifying 'new' male names (names that did not exist before year 2010 with at least 100 people in total)
SELECT
		a.USName AS MaleYear,
		a.MinYear AS FirstYear,
		a.TotalNumber
FROM
		(SELECT 
				USName,
				MIN(USYear) AS MinYear,
				MAX(USYear) AS MaxYear,
				SUM(USNumber) AS TotalNumber
		FROM 
				USNamesTable
		WHERE
				USGender = 'M'
		GROUP BY
				USName)
		AS a
WHERE
		a.MinYear > 2010
AND
		a.TotalNumber > 100
ORDER BY
		a.TotalNumber DESC

**************************************		
--Number of different names per year (name diversity)
SELECT
		USYear,
		FORMAT(COUNT(USName),'###,###') AS CountDifferentNames,
		FORMAT(SUM(USNumber),'###,###') AS AnnualBirths,
		FORMAT(1.0 * COUNT(USName) / SUM(USNumber),'###.#####') AS RatioNamesPerBirths,
		FORMAT(SUM(USNumber) / COUNT(USName),'###,###') AS RatioBirthsPerNames
FROM
		USNamesTable
GROUP BY
		USYear
ORDER BY
		USYear

**************************************
--Identifying names that are popular in both France and the US after 2010
SELECT TOP 20
		us.USName AS FirstName,
		us.USGender AS Gender,
		SUM(us.USNumber) AS USNumber,
		RANK() OVER(ORDER BY SUM(us.USNumber) DESC) AS USRank,
		SUM(fr.FRNumber) AS FRNumber,
		RANK() OVER(ORDER BY SUM(fr.FRNumber) DESC) AS FRRank,
		(RANK() OVER(ORDER BY SUM(us.USNumber) DESC) + RANK() OVER(ORDER BY SUM(fr.FRNumber) DESC))  AS RankSum
FROM
		USNamesTable AS us
INNER JOIN
		FRNamesTable AS fr
ON
		us.USName = fr.FRName AND us.USYear = fr.FRYear AND us.USGender = fr.FRGender
WHERE
		us.USYear > 2010
GROUP BY
		us.USName,
		us.USGender
ORDER BY
		(RANK() OVER(ORDER BY SUM(us.USNumber) DESC) + RANK() OVER(ORDER BY SUM(fr.FRNumber) DESC)) 

**************************************
		
--Correlations with names in France during the same period
SELECT TOP 10
		us.USYear AS YOB,
		us.USName AS FirstName,
		us.USNumber AS NumberBirths,
		RANK() OVER(ORDER BY us.USNumber DESC) AS PopularityRank,
		'US Name'
FROM 
		USNamesTable AS us
UNION ALL
SELECT TOP 10
		fr.FRYear,
		fr.FRName,
		fr.FRNumber,
		RANK() OVER(ORDER BY fr.FRNumber DESC),
		'French Name'
FROM
		FRNamesTable AS fr

**************************************		
--Correlating names popularity with US Presidents names
--Some names (Grover, William, George) had 2 presidents
SELECT
		n.USName,
		n.USGender,
		n.USNumber,
		n.USYear,
		p.StartYear,
		p.EndYear,
		CASE	
			WHEN n.USYear BETWEEN p.StartYear AND p.EndYear THEN 'Yes'
			ELSE 'No'
		END
		AS InPower
FROM
		USNamesTable AS n
INNER JOIN
		USPresidents AS p
ON
		n.USName = p.PresidentName
WHERE
		n.USGender = 'M'
ORDER BY
		n.USName,
		n.USYear