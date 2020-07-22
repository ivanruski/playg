/*
  Create a system-versioned temporal table called Departments with an
  associated history table called DepartmentsHistory in the database
  TSQLV4. The table should have the following columns: deptid INT,
  deptname VARCHAR(25), and mgrid INT, all disallowing NULLs. Also
  include columns called validfrom and validto that define the validity
  period of the row. Define those with precision zero (1 second), and
  make them hidden.
*/

USE TSQLV4
GO

CREATE TABLE Departments
(
    deptid INT NOT NULL PRIMARY KEY,
    deptname VARCHAR(25) NOT NULL,
    mgrid INT NOT NULL,
    validfrom DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    validto DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME (validfrom, validto)
)
WITH (SYSTEM_VERSIONING = ON(HISTORY_TABLE = dbo.DepartmentsHistory))