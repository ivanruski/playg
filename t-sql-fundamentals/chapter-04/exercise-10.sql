-- Write a query that returns for each order the number of days that
-- passed since the same customer’s previous order. To determine recency
-- among orders, use orderdate as the primary sort element and orderid as
-- the tiebreaker:

USE TSQLV4

SELECT O.custid,
       O.orderdate,
       O.orderid,
       DATEDIFF(DAY, 
                (
                    SELECT O2.orderdate
                    FROM Sales.Orders AS O2
                    WHERE O2.custid = O.custid AND 
                          (O2.orderdate < O.orderdate OR
                           O2.orderdate = O.orderdate AND
                           O2.orderid < O.orderid)
                    ORDER BY O2.orderdate DESC, O2.orderid
                    OFFSET 0 ROWS FETCH FIRST 1 ROW ONLY
                ),
                O.orderdate
                )
FROM Sales.Orders AS O
ORDER BY O.custid, O.orderdate