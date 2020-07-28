/*
  Using the CROSS APPLY operator and the function you created in Exercise 6-1, return the two most expensive products for each supplier:
*/

USE TSQLV4

SELECT S.supplierid,
       S.companyname,
       P.productid,
       P.productname,
       P.unitprice
FROM Production.Suppliers AS S
    CROSS APPLY Production.TopProducts(S.supplierid, 2) AS P