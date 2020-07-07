-- Write a query against the Sales.Orders table that return the 
-- three shipped-to countries with the highest avg freight in 2015:

USE TSQLV4

SELECT shipcountry, AVG(freight) AS avgfreight
FROM Sales.Orders
WHERE orderdate >= '20150101'
    and orderdate <= '20151231'
GROUP BY shipcountry
ORDER BY avgfreight DESC
    OFFSET 0 ROWS FETCH FIRST 3 ROWS
    ONLY