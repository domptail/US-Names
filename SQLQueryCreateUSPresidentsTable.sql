USE USNamesDB
GO

--Create Table with the first name of US Presidents with years in office since 1881
CREATE TABLE USPresidentsTable
(
PresidentName varchar(20),
StartYear int,
EndYear int
)
GO

INSERT INTO USPresidentsTable(PresidentName, StartYear, EndYear)
VALUES
('James', 1881, 1881),
('Chester', 1881, 1885),
('Grover', 1885, 1889),
('Benjamin', 1889, 1893),
('Grover', 1893, 1897),
('William', 1897, 1901),
('Theodore', 1901, 1909),
('William', 1909, 1913),
('Woodrow', 1913, 1921), 
('Warren', 1921, 1923),
('Calvin', 1923, 1929),   
('Herbert', 1929, 1933),
('Franklin', 1933, 1945), 
('Harry', 1945, 1953),
('Dwight', 1953, 1961), 
('John', 1961, 1963),
('Lyndon', 1963, 1969),
('Richard', 1969, 1974), 
('Gerald', 1974, 1977),
('Jimmy', 1977, 1981),
('Ronald', 1981, 1989),
('George', 1989, 1993),
('Bill', 1993, 2001),
('George', 2001, 2009),  
('Barack', 2009, 2017)
GO

SELECT * FROM USPresidentsTable

