-- Return US customers, and for each customer return the total number of
-- orders and total quantities:

USE TSQLV4


SELECT c.custid,
       COUNT(DISTINCT(o.orderid)) AS numorders,
       SUM(od.qty) as totalqty
FROM Sales.Customers AS c
    INNER JOIN Sales.Orders AS o
        ON c.custid = o.custid
    INNER JOIN Sales.OrderDetails AS od
        ON od.orderid = o.orderid
WHERE c.country = 'USA'
GROUP BY c.custid
ORDER BY c.custid

-- At first I didn't think of COUNT(DISTINCT), as a result a wrote this:

SELECT custid,
       COUNT(orderid) AS numorders,
       SUM(totalqty) AS totalqty
FROM (
    SELECT co.custid,
           co.orderid,
           SUM(od.qty) AS totalqty
    FROM Sales.OrderDetails AS od
        INNER JOIN (
            SELECT c.custid,
                   o.orderid
            FROM Sales.Customers AS c
                INNER JOIN Sales.Orders AS o
                ON c.custid = o.custid
            WHERE c.country = 'USA'
            GROUP BY c.custid, o.orderid
        ) AS co
        ON od.orderid = co.orderid
    GROUP BY co.custid, co.orderid
    ) AS customerOrdersQty
GROUP BY custid
ORDER BY custid
