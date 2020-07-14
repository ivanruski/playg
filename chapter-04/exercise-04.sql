-- Write a query that returns countries where there are customers but not
-- employees:

USE TSQLV4

SELECT DISTINCT C.country
FROM Sales.Customers AS C
WHERE NOT EXISTS (
    SELECT DISTINCT E.country
    FROM Hr.Employees AS E
    WHERE E.country = C.country
)

-- The solution from the book is pretty good because the subquery can be
-- executed only once instead of for every row

SELECT DISTINCT country
FROM Sales.Customers
WHERE country NOT IN
  (SELECT E.country FROM HR.Employees AS E);