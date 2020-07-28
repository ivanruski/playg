/*
  Explain the difference between the UNION ALL and UNION operators. In what cases are the two equivalent? When they are equivalent, which one should you use?
*/

/*
  UNION ALL do not removes the duplicate rows where as UNION removes them. 

  UNION ALL and UNION are equivalent when we have sets(only with unique rows). They are not equivalent when we have multisets(duplicates are possible)

  Equivalent example:
  S1: (1, 2, 3)
  S2: (4, 5, 6)
  S1 UNION S2 = (1, 2, 3, 4, 5, 6)
  S1 UNION ALL S2 (1, 2, 3, 4, 5, 6)

  Non-equivalent example:
  S1: (1, 2, 3, 3, 6)
  S2: (3, 4, 5, 6)
  S1 UNION S2 = (1, 2, 3, 4, 5, 6)
  S1 UNION ALL S2 (1, 2, 3, 3, 3, 4, 5, 6, 6)
*/

USE TSQLV4;

WITH NumsMultiset
AS
(
    SELECT n
    FROM dbo.Nums
    WHERE n < 4
    
    UNION ALL
    
    SELECT n
    FROM dbo.Nums
    WHERE n = 3 or n = 6
)
SELECT n
FROM NumsMultiset
UNION -- ALL
SELECT n
FROM dbo.Nums
WHERE n BETWEEN 3 AND 6