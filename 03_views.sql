/*
PURPOSE: Creating Virtual Tables for Reporting and Analytics.
*/

USE RetailStoreDB;
GO
-- Combine Products with CategoryName
CREATE OR ALTER VIEW vw_ProductCatalog AS
SELECT
	p.ProductID,
	p.ProductName,
	c.CategoryName,
	p.Price,
	p.StockQuantity,
	CASE
	    WHEN p.StockQuantity = 0 THEN 'Out of  Stock'
	    WHEN p.StockQuantity <= 5 THEN 'Low Stock'
	END AS InventoryStatus
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID;
GO

--Sales per Customer
-- Purpose: Analyze customer performance (Who spent the most?)
CREATE OR ALTER VIEW vw_CustomerSalesSummary AS
SELECT
	c.CustomerID,
	c.FirstName + ' ' + c.LastName AS FullName,
	COUNT(o.OrderID) AS TotalOrders,
	SUM(o.TotalAmount) AS TotalSpend,
	AVG(o.TotalAmount) AS AverangeOrderValue
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName,c.LastName;
GO

-- Complete Order Details
-- Purpose: A detailed report of every product sold, in which order and to whom
CREATE OR ALTER VIEW vw_DetailedOrderReport AS
SELECT
	o.OrderID,
	o.OrderDate,
	c.FirstName + ' ' + c.LastName AS CustomerName,
	p.ProductName,
	od.Quantity,
	od.UnitPrice,
	(od.Quantity *od.UnitPrice) AS LineTotal
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.CustomerID = od.OrderID
JOIN Products  p ON od.ProductID = p.ProductID;
GO

SELECT * FROM vw_ProductCatalog WHERE InventoryStatus = 'Low Stock';
SELECT * FROM vw_CustomerSalesSummary ORDER BY TotalSpend DESC;