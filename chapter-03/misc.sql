-- Return the percentage of the current order value out of of the
-- customer total

USE TSQLV4

SELECT OV.orderid,
       OV.custid,
       OV.val,
       CAST(val * 100. / 
       (
           SELECT SUM(val)
           FROM Sales.OrderValues AS OV2
           WHERE OV2.custid = OV.custid
       ) AS NUMERIC(5,2))
       AS pct
FROM Sales.OrderValues AS OV
ORDER BY custid, orderid