/*
  Write a query against the dbo.Orders table that returns the total quantities for each of the following: (employee, customer, and order year), (employee and order year), and (customer and order year). Include a result column in the output that uniquely identifies the grouping set with which the current row is associated:
*/

USE TSQLV4;

SELECT GROUPING_ID(empid, custid, orderyear) AS groupingset,
       empid,
       custid,
       orderyear,
       SUM(qty) AS sumqty
FROM (
        SELECT empid,
                 custid,
                 YEAR(orderdate) AS orderyear,
                 qty
        FROM dbo.Orders 
    ) AS O
GROUP BY
    GROUPING SETS
    (
        (empid, custid, orderyear),
        (empid, orderyear),
        (custid, orderyear)
    )


