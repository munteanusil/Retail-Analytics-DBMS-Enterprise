USE RetailStoreDB
GO

CREATE OR ALTER PROCEDURE sp_RestockProduct
    @ProductID INT,
    @AddedQuantity INT,
    @NewPrice DECIMAL(10,2) = NULL -- Parametru opțional
AS
BEGIN
    SET NOCOUNT ON;


    IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductID = @ProductID)
    BEGIN
        RAISERROR('Produsul nu a fost găsit!', 16, 1);
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY

        UPDATE Products 
        SET StockQuantity = StockQuantity + @AddedQuantity
        WHERE ProductID = @ProductID;

        IF @NewPrice IS NOT NULL AND @NewPrice > 0
        BEGIN
            UPDATE Products 
            SET Price = @NewPrice 
            WHERE ProductID = @ProductID;
        END

        COMMIT TRANSACTION;
        PRINT 'Stoc actualizat cu succes.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


EXEC sp_RestockProduct @ProductID = 2, @AddedQuantity = 20, @NewPrice = 2300.00;
