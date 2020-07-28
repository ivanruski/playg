/*
  Update the manager ID of department 3 to 13. Call the point in time
  when you apply this update P3.
*/

USE TSQLV4

DECLARE @P3 AS DATETIME2(0) = SYSUTCDATETIME();
-- DECLARE @P3 AS DATETIME2(0) = '2020-07-22 05:33:31'


UPDATE dbo.Departments
    SET
        mgrid = 13
WHERE deptid = 3

SELECT @P3