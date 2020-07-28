/*
  In one transaction, update the name of department 3 to 'Sales and 
  Marketing' and delete department 4. Call the point in time when the
  transaction starts P2.
*/

USE TSQLV4


-- DECLARE @P2 AS DATETIME2(0) = '2020-07-22 05:32:43'

BEGIN TRAN

DECLARE @P2 AS DATETIME2(0) = SYSUTCDATETIME();

UPDATE dbo.Departments
    SET 
        deptname = 'Sales and Marketing'
WHERE deptid = 3

DELETE dbo.Departments
WHERE deptid = 4

SELECT @P2

COMMIT TRAN
