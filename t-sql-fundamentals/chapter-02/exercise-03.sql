-- Write a query against the HR.Employees table that returns
-- employees with a last name containing the letter 'e' twice or
-- more.

USE TSQLV4

SELECT empid,
       firstname,
       lastname
FROM HR.Employees
WHERE lastname LIKE '%e%e%'