/*
  Write a query that generates a virtual auxiliary table of 10 numbers in the range 1 through 10 without using a looping construct. You do not need to guarantee any order of the rows in the output of your solution:
*/

USE TSQLV4;

WITH N10(n)
AS
(
    SELECT 1 UNION SELECT 2 UNION
    SELECT 3 UNION SELECT 4 UNION
    SELECT 5 UNION SELECT 6 UNION
    SELECT 7 UNION SELECT 8 UNION
    SELECT 9 UNION SELECT 10
)
SELECT N1.n
FROM N10 AS N1




