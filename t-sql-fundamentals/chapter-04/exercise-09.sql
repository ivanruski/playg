-- Explain the difference betweeen IN and EXISTS

-- IN has the form: scalar IN (SELECT x FROM dbo.XS).
-- IN checks if the scalar is present in the result table.
-- IN can't be used with a table that has more than one column.
-- IN can return TRUE, FALSE or UNKNOWN(if the table countains NULL).

-- EXISTS has the from: EXISTS (SELECT * FROM dbo.XS)
-- EXISTS returns false if the table has 0 rows and true otherwise

-- Both can be used with NOT. (NOT IN, NOT EXISTS)
-- EXISTS is more safe to be used with NOT because EXISTS returns only
-- true or false where as if we use NOT IN with a table that has NULL
-- the result will be UNKNOWN


