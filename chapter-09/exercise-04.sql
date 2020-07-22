/*
  Drop the table Departments and its associated history table.
*/

USE TSQLV4

-- TableTemporalType enum (https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.management.smo.tabletemporaltype?view=sql-smo-160)
-- HistoryTable	      1     history table of a system-versioned table
-- None               0     System time period
-- SystemVersioned    2     System time table

DECLARE @TABLE_NAME AS NVARCHAR(50) = 'dbo.Departments'

IF OBJECTPROPERTY(OBJECT_ID(@TABLE_NAME), 'TableTemporalType') = 2
BEGIN
    ALTER TABLE dbo.Departments SET(SYSTEM_VERSIONING = OFF)
    DROP TABLE dbo.Departments, dbo.DepartmentsHistory
END
