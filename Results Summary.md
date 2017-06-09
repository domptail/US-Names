# AN ANALYSIS OF FIRST NAMES IN THE US IN 1880-2015

## Introduction:

This is a short analysis of first names in the US between 1880 and 2015 using SQL.

The data files can be downloaded from the US Social Security [Website](https://www.ssa.gov/oact/babynames/limits.html).

There are 136 files (txt format), each corresponding to one year between 1880 and 2015.

Each file contains 3 features:
- first name,
- gender,
- number of people born with given name, gender, and year of birth.

There are 1,858,689 entries in total.

## Methodology:

The purpose of this project was to practice SQL queries.

First, the data from all 136 files were uploaded into one table using SQL Bulk Insert in a Cursor 
(see [query](https://github.com/domptail/US-Names/blob/master/SQLQueryCreateDatabase.sql)). 

Second, two additional tables were created with the first names of US Presidents during the same period 
(see [query](https://github.com/domptail/US-Names/blob/master/SQLQueryCreateUSPresidentsTable.sql) 
and first names in France between 1900 and 2015 
(see [query](https://github.com/domptail/US-Names/blob/master/SQLQueryCreateFRNamesTable.sql)).

Third, the data were analyzed using SQL SELECT statements 
(see [query](https://github.com/domptail/US-Names/blob/master/SQLQueryNameTrends.sql)).

Finally, some visualizations were prepared using Power BI based on the results of the SQL queries.

## Results:

Below is a summary of some of the most interesting results.

