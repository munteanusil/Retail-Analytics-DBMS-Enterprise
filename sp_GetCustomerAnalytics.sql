USE RetailStoreDB
GO

CREATE OR ALTER PROCEDURE sp_GetCustomerAnalytics
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Returnează un set de date cu statistici despre client
    SELECT 
        c.FirstName + ' ' + c.LastName AS CustomerName,
        COUNT(o.OrderID) AS TotalOrders,
        ISNULL(SUM(o.TotalAmount), 0) AS TotalValueSpent,
        (SELECT TOP 1 p.ProductName 
         FROM OrderDetails od 
         JOIN Products p ON od.ProductID = p.ProductID
         JOIN Orders o2 ON od.OrderID = o2.OrderID
         WHERE o2.CustomerID = @CustomerID
         GROUP BY p.ProductName 
         ORDER BY SUM(od.Quantity) DESC) AS MostPurchasedProduct
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.CustomerID = @CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName;
END;
GO

EXEC sp_GetCustomerAnalytics @CustomerID = 1;