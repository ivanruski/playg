-- Write a query that calculates a running-total quantity for each
-- customer (there is also 'and a month' in the original problem 
-- but I think that 'and a month' is a bit misleading):

USE TSQLV4

SELECT CO.custid,
       CO.ordermonth,
       CO.qty,
       (
           SELECT SUM(CO2.qty)
           FROM Sales.CustOrders AS CO2
           WHERE CO2.custid = CO.custid AND
                 CO2.ordermonth <= CO.ordermonth
       ) AS runqty
FROM Sales.CustOrders AS CO
ORDER BY CO.custid, CO.ordermonth