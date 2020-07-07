-- To check the validity of the data, write a query against the 
-- HR.Employees table taht returns employees with a last name that starts -- with a lowercase English letter in the range 'a' through 'z'.
-- Remember that the collation of the sample database is case insensitive
-- (Lating_General_CI_AS)

USE TSQLV4

SELECT empid,
       lastname
FROM HR.Employees
WHERE lastname COLLATE Latin1_General_Bin like N'[a-z]%' 

-- The Latin1_General_CS_AS collation doesnt work because the letters are
-- orderer in the following way: [a A b B .. z Z]. Meaning that [a-z]range
-- will include all of the latters except Z.
-- That's why I am using Latin1_General_Bin. Here the leters are ordered
-- A B C .. Z a b c .. z