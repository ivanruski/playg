/*
  Write a query against the dbo.Orders table that computes for each customer order both the difference between the current order quantity and the customer’s previous order quantity and the difference between the current order quantity and the customer’s next order quantity:
*/

USE TSQLV4;

SELECT custid,
       orderid,
       qty,
       qty - LAG(qty) OVER(PARTITION BY custid
                     ORDER BY orderdate, orderid)
                     AS diffprev,
       qty - LEAD(qty) OVER(PARTITION BY custid
                     ORDER BY orderdate, orderid)
                     AS diffnext
FROM dbo.Orders