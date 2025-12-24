USE RetailStoreDB;
GO


CREATE OR ALTER PROCEDURE sp_PlaceOrder
    @CustomerID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
  
    SET NOCOUNT ON;
    
    DECLARE @AvailableStock INT;
    DECLARE @ProductPrice DECIMAL(10,2);
    DECLARE @InsertedOrderID INT;

    SELECT @AvailableStock = StockQuantity, @ProductPrice = Price 
    FROM Products WHERE ProductID = @ProductID;

    IF @AvailableStock IS NULL
    BEGIN
        RAISERROR('Eroare: Produsul nu există.', 16, 1);
        RETURN;
    END

    IF @AvailableStock < @Quantity
    BEGIN
        RAISERROR('Eroare: Stoc insuficient!', 16, 1);
        RETURN;
    END

   
    BEGIN TRANSACTION;

    BEGIN TRY
     
        UPDATE Products 
        SET StockQuantity = StockQuantity - @Quantity 
        WHERE ProductID = @ProductID;

        
        INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
        VALUES (@CustomerID, GETDATE(), @ProductPrice * @Quantity);

        
        SET @InsertedOrderID = SCOPE_IDENTITY();

        
        INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
        VALUES (@InsertedOrderID, @ProductID, @Quantity, @ProductPrice);

       
        COMMIT TRANSACTION;
        PRINT 'Comanda a fost procesată cu succes! Order ID: ' + CAST(@InsertedOrderID AS VARCHAR);
        
    END TRY
    BEGIN CATCH
       
        ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO