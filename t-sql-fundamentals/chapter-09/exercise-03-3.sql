/*
  Query the state of the table Departments in the period between P2 and
  P3. Be explicit about the column names in the SELECT list, and
  include the validfrom and validto columns:
*/

DECLARE @P2 AS DATETIME2(0) = '2020-07-22 05:32:43'
DECLARE @P3 AS DATETIME2(0) = '2020-07-22 05:33:31'

USE TSQLV4

SELECT deptid, deptname, mgrid, validfrom, validto
FROM dbo.Departments
FOR SYSTEM_TIME BETWEEN @P2 AND @P3