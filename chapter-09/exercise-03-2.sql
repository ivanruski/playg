/* 
  Query the state of the table Departments at a point in time after P2
  and before P3:
*/

DECLARE @P2 AS DATETIME2(0) = '2020-07-22 05:32:43'
DECLARE @P3 AS DATETIME2(0) = '2020-07-22 05:33:31'

USE TSQLV4

SELECT deptid, deptname, mgrid, validfrom, validto
FROM dbo.Departments
FOR SYSTEM_TIME FROM @P2 TO @P3 -- NOT SURE ABOUT THIS