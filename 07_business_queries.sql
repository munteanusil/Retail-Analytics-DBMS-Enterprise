/*
--------------------------------------------------------------------
PURPOSE: Complex Business Intelligence Queries & Analytics.
--------------------------------------------------------------------
*/

USE RetailStoreDB;
GO

--  REVENUE ANALYSIS BY CATEGORIES
-- Which categories bring in the most money?
SELECT 
    c.CategoryName,
    COUNT(od.OrderID) AS TotalSalesCount,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue,
    RANK() OVER (ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS RevenueRank
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName;
GO

--  IDENTIFYING VIP CUSTOMERS (RFM - Recency, Frequency, Monetary)
-- Who are our most valuable customers?
SELECT 
    FullName,
    TotalOrders,
    TotalSpent,
    CASE 
        WHEN TotalSpent > 5000 THEN 'Platinum Customer'
        WHEN TotalSpent BETWEEN 2000 AND 5000 THEN 'Gold Customer'
        ELSE 'Standard'
    END AS CustomerTier
FROM vw_CustomerSalesSummary
ORDER BY TotalSpent DESC;
GO

--  ANALYSIS OF "DEAD STOCK" PRODUCTS
--  What products have never been sold and are taking up space in the warehouse?
SELECT 
    p.ProductName,
    p.StockQuantity,
    p.Price
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL
ORDER BY p.StockQuantity DESC;
GO

--  AVERAGE ORDER VALUE (AOV) PER MONTH
--  How is the average amount spent by customers evolving?
SELECT 
    FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
    COUNT(OrderID) AS NumberOfOrders,
    SUM(TotalAmount) AS MonthlyRevenue,
    AVG(TotalAmount) AS AverageOrderValue
FROM Orders
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY OrderMonth DESC;
GO

-- TOP SELLING PRODUCTS IN EACH CATEGORY
-- What is the "best-seller" of each section?
WITH ProductRanking AS (
    SELECT 
        c.CategoryName,
        p.ProductName,
        SUM(od.Quantity) AS TotalSold,
        ROW_NUMBER() OVER (PARTITION BY c.CategoryName ORDER BY SUM(od.Quantity) DESC) as RankPerCategory
    FROM Categories c
    JOIN Products p ON c.CategoryID = p.CategoryID
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY c.CategoryName, p.ProductName
)
SELECT CategoryName, ProductName, TotalSold
FROM ProductRanking
WHERE RankPerCategory = 1;
GO