/*
  Insert into the dbo.Customers table a row with the following information:
  
  custid: 100
  companyname: Coho Winery
  country: USA
  region: WA
  city: Redmond
*/

USE TSQLV4

INSERT INTO dbo.Customers(custid, companyname, country, region, city)
VALUES (100, 'Coho Winery', 'USA', 'WA', 'Redmond')

