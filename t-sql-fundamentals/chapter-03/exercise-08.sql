-- Explain why the following query isn’t a correct solution query for
-- Exercise 07

USE TSQLV4

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON O.custid = C.custid
WHERE O.orderdate = '20160212'
   OR O.orderid IS NULL;

-- The following query will yield wrong results because the left outer
-- join will return all customers and their orders + those customers who
-- doesn't have orders. Which means that the 'O.orderid IS NULL' will
-- filter only those customers who doesn't have orders. We want to filter
-- those customers who hadn't placed orders on '20160212'
