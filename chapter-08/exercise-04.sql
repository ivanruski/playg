/*
  Run the following query against dbo.Customers, and notice that some
  rows have a NULL in the region column: SELECT * FROM dbo.Customers;

  Update the dbo.Customers table, and change all NULL region values to
  <None>. Use the OUTPUT clause to show the custid, oldregion, and
  newregion:
*/

USE TSQLV4

UPDATE dbo.Customers
    SET region = '<None>'
OUTPUT inserted.custid AS custid,
       deleted.region AS oldregion,
       inserted.region AS newregion
WHERE region IS NULL