-- Write a query that returns customers who ordered product 12:

USE TSQLV4

SELECT C.custid,
       C.companyname
FROM Sales.Customers AS C
WHERE EXISTS (
    SELECT O.orderid
    FROM Sales.Orders AS O
    WHERE O.custid = C.custid AND 
          EXISTS (
            SELECT *
            FROM Sales.OrderDetails AS OD
            WHERE OD.productid = 12 AND OD.orderid = O.orderid))