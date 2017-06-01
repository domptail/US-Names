-- TO ENABLE xp_cmdShell (https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/xp-cmdshell-server-configuration-option)
-- To allow advanced options to be changed.
EXEC sp_configure 'show advanced options', 1
GO
-- To update the currently configured value for advanced options.
RECONFIGURE
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO


--Create and use new database 
CREATE DATABASE USNamesDB2
GO

USE USNamesDB2
GO

--Create Table for US Names data
CREATE TABLE USNamesTable
(
USName nvarchar(50) NOT NULL,
USGender varchar(1),
USNumber bigint,
USYear nvarchar(50)
)
GO

--Create View of the US Names table with only 3 columns for the Bulk Insert because the txt files have only 3 columns
CREATE VIEW USNamesView AS
	SELECT
			USName,
			USGender,
			USNumber
	FROM
			USNamesTable
GO

--Bulk insert multiples .txt files from a folder 
--Create Table to loop through filenames 
CREATE TABLE FilesNamesTable
(
USFilePath VARCHAR(255),
USFileName VARCHAR(255)
)
GO

--Variables
DECLARE @filename varchar(255),
        @path     varchar(255),
        @sql      varchar(8000),
        @cmd      varchar(1000)

--Get the list of files  
--xp_cmdshell: Spawns a Windows command shell and passes in a string for execution. Any output is returned as rows of text.
SET @path = 'C:\kimdsdata\names'
SET @cmd = 'dir '  + '"' + @path + '\*.txt" /b'
INSERT INTO  FilesNamesTable(USFileName)
	EXEC Master..xp_cmdShell @cmd

DELETE FROM	FilesNamesTable WHERE USFileName IS NULL
UPDATE FilesNamesTable SET USFilePath = @path WHERE USFilePath IS NULL

--Cursor loop
--@@FETCH_STATUS = 0 (successful), -1 (failed), -2 (row missing)
--Need to use ROWTERMINATOR = '0x0a' (instead of \n due to the file format)
DECLARE c1 CURSOR FOR 
	SELECT USFilePath, USFileName 
	FROM FilesNamesTable 
	WHERE USFileName like '%.txt%'
OPEN c1
FETCH NEXT FROM c1 INTO @path, @filename
WHILE @@FETCH_STATUS <> -1
	BEGIN
		SET @sql = 'BULK INSERT USNamesView 
						FROM '''+ @path + '\' + @filename +''' 
						WITH (
							  FIELDTERMINATOR = '','', 
							  ROWTERMINATOR = ''0x0a''							
							  )'

					+ 'UPDATE USNamesTable 
					SET [USYear] = ''' + @filename + ''' 
					WHERE [USYear] IS NULL;'
							
		PRINT @sql
		EXEC (@sql)
		FETCH NEXT FROM c1 INTO @path,@filename
	END
CLOSE c1
DEALLOCATE c1
GO

--Delete the temporary table and view
DROP TABLE FilesNamesTable
DROP VIEW USNamesView
GO

--Extract the year from the name of the file in the USYear column
UPDATE USNamesTable 
SET USYear = SUBSTRING(USYear, PATINDEX('%[0-9]%', USYear), 4) FROM USNamesTable
GO

--Modify the type of USYear column from string to integer
ALTER TABLE USNamesTable
ALTER COLUMN USYear int
GO

SELECT * FROM USNamesTable
GO