/*
  You are given the following query:
        
    SELECT country, region, city
    FROM HR.Employees
    UNION ALL
    SELECT country, region, city
    FROM Production.Suppliers;

  You are asked to add logic to the query so that it guarantees that the rows from Employees are returned in the output before the rows from Suppliers. Also, within each segment, the rows should be sorted by country, region, and city:
*/

USE TSQLV4;

SELECT U.country, U.region, U.city
FROM (
    SELECT country, region, city, 0 as sortcol
    FROM HR.Employees

    UNION ALL

    SELECT country, region, city, 1 as sortcol
    FROM Production.Suppliers
) AS U
ORDER BY U.sortcol, U.country, U.region, U.city;