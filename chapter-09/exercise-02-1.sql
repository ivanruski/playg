/*
  Insert four rows to the table Departments with the following details,
  and note the time when you apply this insert (call it P1):
  
  deptid: 1, deptname: HR, mgrid: 7
  deptid: 2, deptname: IT, mgrid: 5
  deptid: 3, deptname: Sales, mgrid: 11
  deptid: 4, deptname: Marketing, mgrid: 13
*/

USE TSQLV4

DECLARE @P1 AS DATETIME2(0) = SYSUTCDATETIME();
--DECLARE @P1 AS DATETIME2(0) = '2020-07-22 05:31:01'

INSERT INTO dbo.Departments(deptid, deptname, mgrid)
VALUES (1, 'HR', 7),
       (2, 'IT', 5),
       (3, 'Sales', 11),
       (4, 'Marketing', 13)

SELECT @P1

