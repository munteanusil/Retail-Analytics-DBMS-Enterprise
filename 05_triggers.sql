USE RetailStoreDB
GO

CREATE TABLE PriceHistory (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE(),
    ChangedBy NVARCHAR(100)
);
GO

CREATE OR ALTER TRIGGER trg_AuditPriceChange
ON Products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Price)
    BEGIN
        INSERT INTO PriceHistory (ProductID, OldPrice, NewPrice, ChangedBy)
        SELECT 
            d.ProductID, 
            d.Price,   
            i.Price,   
            SYSTEM_USER
        FROM deleted d
        JOIN inserted i ON d.ProductID = i.ProductID;
    END
END;
GO


CREATE OR ALTER TRIGGER trg_LowStockAlert
ON Products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM inserted WHERE StockQuantity <= 5 AND StockQuantity > 0)
    BEGIN
        DECLARE @ProdName NVARCHAR(255);
        SELECT @ProdName = ProductName FROM inserted;
        
        PRINT 'ATENȚIE: Stocul pentru produsul [' + @ProdName + '] este critic (sub 5 unități)!';
    END
END;
GO