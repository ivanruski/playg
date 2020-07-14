-- Write a query against the Sales.Orders table that calculates row
-- numbers for orders based on order date ordering (using the order ID
-- as the tiebraker) for each customer separately

USE TSQLV4

SELECT custid,
       orderdate,
       orderid,
       ROW_NUMBER() 
        OVER(PARTITION BY custid ORDER BY orderdate, orderid) as rownum
FROM Sales.Orders
-- ORDER BY inside OVER doesn't guarantee the same results every time
-- This is why I am using order by here as well
ORDER BY custid, rownum