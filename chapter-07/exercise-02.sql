/*
  Earlier in the chapter in the section “Ranking window functions,” I provided the following query against the Sales.OrderValues view to return distinct values and their associated row numbers:
  
    SELECT val, ROW_NUMBER() OVER(ORDER BY val) AS rownum
    FROM Sales.OrderValues
    GROUP BY val;
  
  Can you think of an alternative way to achieve the same task?
*/

USE TSQLV4;

-- My solutions was wrong. With RANK, DISTINCT function will eliminate
-- the duplicates (vals) but the rownum will not be correct.
SELECT DISTINCT(val),
       RANK() OVER(ORDER BY val) AS rownum
FROM Sales.OrderValues; 

-- This is the correct one
WITH C AS
(
  SELECT DISTINCT val
  FROM Sales.OrderValues
)
SELECT val, ROW_NUMBER() OVER(ORDER BY val) AS rownum
FROM C;
