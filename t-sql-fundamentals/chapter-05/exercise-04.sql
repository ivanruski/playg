/*
  Write a solution using a recursive CTE that returns the management chain leading to Patricia Doyle (employee ID 9):
*/

USE TSQLV4;

WITH Employees_chain_DESC
AS
(
    SELECT empid,
           mgrid,
           firstname,
           lastname
    FROM Hr.Employees
    WHERE empid = 9

    UNION ALL

    SELECT E.empid,
           E.mgrid,
           E.firstname,
           E.lastname
    FROM Hr.Employees AS E
        INNER JOIN Employees_chain_DESC AS P
        ON E.empid = P.mgrid
)
SELECT empid,
    mgrid,
    firstname,
    lastname
FROM Employees_chain_DESC;