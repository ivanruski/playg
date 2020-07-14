/* 
  Create an inline TVF that accepts as inputs a supplier ID (@supid AS INT) and a requested number of products (@n AS INT). The function should return @n products with the highest unit prices that are supplied by the specified supplier ID:
*/

USE TSQLV4
DROP FUNCTION IF EXISTS Production.TopProducts;
GO

CREATE FUNCTION Production.TopProducts(@supid AS INT, @n AS INT)
RETURNS TABLE
AS
RETURN
SELECT productid,
       productname,
       unitprice
FROM Production.Products
WHERE supplierid = @supid
ORDER BY unitprice DESC, productid
OFFSET 0 ROWS FETCH FIRST @n ROWS ONLY;
