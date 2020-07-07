-- Explain the difference between the following 2 queries:


-- Query 1
USE TSQLV4

SELECT empid, COUNT(*) AS numorders
FROM Sales.Orders
WHERE orderdate < '20160501'
GROUP BY empid

-- Query 2
USE TSQLV4

SELECT empid, COUNT(*) AS numorders
From Sales.Orders
GROUP BY empid
HAVING MAX(orderdate) < '20160501'

-- Query 1 will return all orders with orderdate less than 2016-05-01
-- and the it will group by empid or on plain english:
-- Give me the number of orders each employee has up to 2016-04-31

-- Query 2 will count employee orders only if he/she hasn't made any
-- any order after 2016-05-01