INSERT INTO Employees (FullName, Position, HireDate, Salary)
VALUES
    ('John Doe', 'Manager', '2020-01-01', 5000),
    ('Emily Johnson', 'Sales Representative', '2021-03-15', 4000),
    ('Michael Williams', 'Sales Representative', '2021-05-20', 4000),
    ('Jessica Brown', 'Cashier', '2021-06-10', 3500),
    ('Daniel Jones', 'Stock Clerk', '2021-07-05', 3000),
	('Sarah Lee', 'Sales', '2021-02-02', 3000);
GO

--(Найменування, Категорія, кількість, Ціна, Виробник, ціна зі скидкою)
INSERT INTO Products (Name, Category, Quantity, Cost, Manufacturer, SalePrice)
VALUES
    ('Running Shoes', 'Footwear', 50, 99.99, 'Nike', 79.99),
    ('Basketball', 'Sports Equipment', 30, 19.99, 'Spalding', 29.99),
    ('Yoga Mat', 'Fitness Accessories', 40, 35.99, 'Gaiam', 24.99),
    ('Dumbbells', 'Fitness Equipment', 20, 44.99, 'CAP Barbell', 39.99),
    ('Tennis Racket', 'Sports Equipment', 25, 99.99, 'Wilson', 89.99),
    ('Gym Bag', 'Accessories', 35, 59.99, 'Adidas', 49.99),
    ('Cycling Helmet', 'Cycling Accessories', 30, 69.99, 'Bell', 59.99),
    ('Swimming Goggles', 'Swimming Accessories', 40, 34.99, 'Speedo', 24.99),
    ('Jump Rope', 'Fitness Accessories', 50, 19.99, 'Everlast', 14.99),
    ('Soccer Ball', 'Sports Equipment', 20, 39.99, 'Adidas', 29.99),
    ('Sports Water Bottle', 'Accessories', 60, 17.99, 'CamelBak', 12.99),
    ('Hiking Backpack', 'Outdoor Gear', 25, 179.99, 'Osprey', 119.99),
    ('Golf Clubs Set', 'Golf Equipment', 15, 399.99, 'Callaway', 299.99),
    ('Treadmill', 'Fitness Equipment', 10, 999.99, 'ProForm', 899.99),
    ('Snowboard', 'Winter Sports Equipment', 15, 249.99, 'Burton', 249.99),
    ('Climbing Harness', 'Climbing Gear', 20, 169.99, 'Black Diamond', 99.99),
    ('Baseball Bat', 'Sports Equipment', 25, 50.99, 'Louisville Slugger', 49.99),
    ('Punching Bag', 'Boxing Equipment', 10, 130.99, 'Everlast', 129.99),
    ('Volleyball', 'Sports Equipment', 20, 30.99, 'Mikasa', 27.99),
    ('Weight Bench', 'Fitness Equipment', 15, 240.99, 'Marcy', 229.99),
    ('Яблука', 'Footwear', 50, 99.99, 'Nike', 79.99);

	INSERT INTO Customers (FullName, Email, Phone, Gender, RegistrationDate, DiscountPercent, SubscribedToNewsletter)
VALUES
    ('John Doe', 'john@example.com', '1234567890', 'Male', '2020-02-05', 0.00, 1),
    ('Jane Smith', 'jane@example.com', '9876543210', 'Female', '2021-07-05', 0.00, 1),
    ('Michael Johnson', 'michael@example.com', '5551234567', 'Male', '2019-07-15', 0.00, 1),
    ('Emily Williams', 'emily@example.com', '5559876543', 'Female', '2020-01-05', 0.00, 1),
    ('James Brown', 'james@example.com', '9998887776', 'Male', '2011-02-25', 0.00, 1),
    ('Sarah Lee', 'sarah@example.com', '1112223334', 'Female', '2023-11-08', 0.00, 1),
    ('Robert Miller', 'robert@example.com', '4445556667', 'Male', '2020-12-15', 0.00, 1),
    ('Jessica Taylor', 'jessica@example.com', '7778889990', 'Female', '2019-03-03', 0.00, 1),
    ('William Wilson', 'william@example.com', '2223334445', 'Male', '2021-01-12', 0.00, 1),
    ('Amanda Martinez', 'amanda@example.com', '6667778881', 'Female', '2020-04-02', 0.00, 1);

	--генератор случайних покупок
	INSERT INTO Sales (ProductId, SalePrice, Quantity, SaleDate, CustomerId, EmployeeId)
SELECT TOP 10
    p.ProductId,
    p.SalePrice,
    1 AS Quantity,
    GETDATE() AS SaleDate,
    c.CustomerId,
    e.EmployeeId
FROM
    Products p
    CROSS JOIN Customers c
    CROSS JOIN Employees e
ORDER BY
    NEWID();
