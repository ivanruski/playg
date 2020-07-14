/*
  Create a view that returns the total quantity for each employee and year:
*/
GO
USE TSQLV4;

GO
DROP VIEW IF EXISTS Sales.VEmpOrders

GO
CREATE VIEW Sales.VEmpOrders
AS
SELECT O.empid,
       YEAR(O.orderdate) AS orderyear,
       SUM(OD.qty) AS qty
FROM Sales.Orders AS O
    INNER JOIN Sales.OrderDetails AS OD
    ON OD.orderid = O.orderid
GROUP BY O.empid, YEAR(O.orderdate);

-- Usage: 

-- SELECT * FROM Sales.VEmpOrders ORDER BY empid, orderyear;