/*
  In this exercise, you’ll modify data in the table Departments. Note the
  point in time in UTC when you submit each statement, and mark those as
  P1, P2, and so on. You can do so by invoking the SYSUTCDATETIME
  function in the same batch in which you submit the modification.
  Another option is to query the Departments table and its associated
  history table and to obtain the point in time from the validfrom and
  validto columns.
*/

USE TSQLV4

SELECT *
FROM dbo.Departments