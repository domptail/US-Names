USE USNamesDB
GO

**************************************
--Show the trend of the name Kim over the years
SELECT 
		USName,
		USNumber,
		USGender,
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
--Identifying the most gender neutral names
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
ORDER BY
		ABS(50.0 - (100.0 * F.FemaleNumber / (F.FemaleNumber + M.MaleNumber))),
		(F.FemaleNumber + M.MaleNumber) DESC

**************************************		
