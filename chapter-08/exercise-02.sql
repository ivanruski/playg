/*
  Delete from the dbo.Orders table orders that were placed before August
  2014. Use the OUTPUT clause to return the orderid and orderdate values
  of the deleted orders:
*/

USE TSQLV4

DELETE dbo.Orders
OUTPUT deleted.orderid, deleted.orderdate
WHERE orderdate < '2014-08-01'