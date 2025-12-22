use RetailStoreDB

INSERT INTO Categories (CategoryName) VALUES
('Electronics'),('Home Applications'),('Books'),('Clothing'),
('Toys'),('Sports'),('Beauty'),('Automotive'),('Garden'),('Groceries');
GO

INSERT INTO Products (ProductName, CategoryID, Price, StockQuantity) VALUES 
('iPhone 15', 1, 4500.00, 50),
('Washing Machine LG', 2, 2200.00, 15),
('SQL for Beginners Book', 3, 85.50, 100),
('Nike Air Max', 4, 600.00, 30),
('LEGO Star Wars Set', 5, 450.00, 20),
('Yoga Mat', 6, 120.00, 80),
('Hydrating Serum', 7, 150.00, 200),
('Engine Oil 5W30', 8, 210.00, 45),
('Lawn Mower', 9, 1300.00, 5),
('Organic Coffee Beans', 10, 45.00, 300);
GO


INSERT INTO Customers(FirstName,LastName,Email) Values
('Ion','Niculae','ion.niculae@email.com'),
('Maria','Georgescu','maria.gi@email.com'),
('Elena','Dumitru','elena.dumi@email.com'),
('Cristian', 'Vasile', 'cristi.v@email.com'),
('Ana', 'Stan', 'ana.stan@email.com'),
('Mihai', 'Radu', 'mihai.radu@email.com'),
('Laura', 'Stoica', 'laura.s@email.com'),
('Gabriel', 'Dinu', 'gabi.dinu@email.com'),
('Silvia', 'Lazar', 'silvia.l@email.com'),
('Adrian', 'Marin', 'adi.marin@email.com');
GO

SELECT CustomerID, FirstName FROM Customers;

INSERT INTO Orders(CustomerID,TotalAmount) VAlUES
(1,4500.00), (2,2200.00),(3,85.50),(4,600.00),(5,450.00);

INSERT INTO OrderDetails(OrderID,ProductID,Quantity,UnitPrice) VALUES
(1,1,1,4500.00),
(2, 2, 1, 2200.00), -- Order 2 Washing Machine
(3, 3, 1, 85.50),   -- Comanda 3 are Book
(4, 4, 1, 600.00),   -- Comanda 4 are Shoes
(5, 5, 1, 450.00);   -- Comanda 5 are LEGO
GO
