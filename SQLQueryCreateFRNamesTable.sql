USE USNamesDB
GO

CREATE TABLE FRNamesTable
(
FRGender varchar(1),
FRName varchar(25),
FRYear varchar(4), --because there are some non-numeric entries
FRNumber float --because there are some non-numeric entries
)
GO

--The file is available on INSEE's website: 'https://www.insee.fr/fr/statistiques/2540004#consulter'
BULK INSERT FRNamesTable
    FROM 'C:\kimdsdata\FRNames\nat2015.txt'
    WITH
    (
    CODEPAGE = 'ACP', --To read French letters é, è, etc.
	FIRSTROW = 2,
    FIELDTERMINATOR = '\t', 
    ROWTERMINATOR = '0x0a'  
    )
GO

--Delete rows with unknown years (XXXX), which corresponds to years with less than 3 people for a given name
DELETE FROM FRNamesTable
WHERE FRYear = 'XXXX'
GO

--Convert FRYear column from varchar to numeric type
ALTER TABLE FRNamesTable
ALTER COLUMN FRYear int
GO

--Convert gender from 1 (male) / 2(female) to M (male) / F (female) to match USNamesTable
UPDATE FRNamesTable
SET FRGender = REPLACE(FRGender, '1', 'M')
WHERE FRGender = '1'

UPDATE FRNamesTable
SET FRGender = REPLACE(FRGender, '2', 'F')
WHERE FRGender = '2'
GO

SELECT * FROM FRNamesTable