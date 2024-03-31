
USE SportStore;
GO
--1
CREATE TRIGGER UpdateProductQuantity
ON Products
INSTEAD OF INSERT
AS
BEGIN
    -- Оновлюємо кількість товару, якщо він вже існує
    UPDATE p
    SET p.Quantity = p.Quantity + i.Quantity
    FROM Products p
    JOIN inserted i ON p.Name = i.Name AND p.Manufacturer = i.Manufacturer;

    -- Вставляємо новий товар, якщо його немає
    INSERT INTO Products (Name, Category, Quantity, Cost, Manufacturer, SalePrice)
    SELECT i.Name, i.Category, i.Quantity, i.Cost, i.Manufacturer, i.SalePrice
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Products p 
        WHERE p.Name = i.Name AND p.Manufacturer = i.Manufacturer
    );
END;

--Приклад 1 позіція є, зміюється лише кількість. 2 позіції немає
INSERT INTO Products (Name, Category, Quantity, Cost, Manufacturer, SalePrice)
VALUES
    ('Running Shoes', 'Footwear', 50, 99.99, 'Nike', 79.99),
    ('Basketball_red', 'Sports Equipment', 30, 19.99, 'Spalding', 29.99);

--2
CREATE TRIGGER ArchiveEmployee
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO ArchivedEmployees (EmployeeId, FullName, Position, HireDate, Salary, TerminationDate)
    SELECT EmployeeId, FullName, Position, HireDate, Salary, GETDATE() AS TerminationDate
    FROM deleted;
END;



--3
CREATE TRIGGER PreventNewSeller
ON Employees
AFTER INSERT
AS
BEGIN
    DECLARE @EmployeeCount INT;
    SELECT @EmployeeCount = COUNT(*) FROM Employees;

    IF @EmployeeCount > 6
    BEGIN
        RAISERROR ('Неможливо додати нового продавця. Кількість продавців перевищує 6.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--перевірка
INSERT INTO Employees (FullName, Position, HireDate, Salary)
VALUES
    ('Bob Miler', 'Manager', '2023-01-01', 6000);


--4
CREATE TRIGGER CheckDuplicateCustomers
ON Customers
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Customers c ON i.FullName = c.FullName
        WHERE i.CustomerId <> c.CustomerId
    )
    BEGIN
        INSERT INTO DuplicateCustomersLog (FullName, DuplicateDateTime)
        SELECT FullName, GETDATE()
        FROM inserted;
    END
END;
--такой таблици нет(структура єтого магазина отстой я 5 лет работал в 1с поддержки худших вопросов невидел)
INSERT INTO Customers (FullName, Email, Phone, Gender, OrderHistory, DiscountPercent, SubscribedToNewsletter)
VALUES
    ('John Doe', 'john@example.com', '1234567890', 'Male', NULL, 0.00, 1);


--5
CREATE TRIGGER MoveOrderHistoryOnDelete
ON Customers
AFTER DELETE
AS
BEGIN
    INSERT INTO PurchaseHistory (CustomerId, PurchaseDate, PurchaseDetails)
    SELECT d.CustomerId, GETDATE(), d.OrderHistory
    FROM deleted d;
END;

--6
CREATE TRIGGER PreventAddingExistingSeller
ON Employees
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Customers c ON i.FullName = c.FullName
        WHERE i.Position = 'Salesperson'
    )
    BEGIN
        RAISERROR('Запис існує. Додавання нового продавця скасовується.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO Employees (FullName, Position, HireDate, Salary)
        SELECT FullName, Position, HireDate, Salary
        FROM inserted;
    END;
END;

INSERT INTO Employees (FullName, Position, HireDate, Salary)
VALUES
('Amanda Martinez', 'Manager', '2020-01-01', 5000);


--7
CREATE TRIGGER PreventAddingExistingCustomer
ON Customers
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Employees e ON i.FullName = e.FullName
        WHERE e.Position = 'Salesperson'
    )
    BEGIN
        RAISERROR('Cannot add new customer. This person already exists in the Employees table as a salesperson.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO Customers (FullName, Email, Phone, Gender, OrderHistory, DiscountPercent, SubscribedToNewsletter)
        SELECT FullName, Email, Phone, Gender, OrderHistory, DiscountPercent, SubscribedToNewsletter
        FROM inserted;
    END;
END;
--перевірка
INSERT INTO Customers (FullName, Email, Phone, Gender, OrderHistory, DiscountPercent, SubscribedToNewsletter)
VALUES
    ('John Doe', 'john@example.com', '1234567890', 'Male', NULL, 0.00, 1);


--8
CREATE TRIGGER PreventProducts
ON Sales
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Products p ON i.ProductId = p.ProductId
        WHERE p.Name IN ('Яблука', 'Груші', 'Сливи', 'Кінза')
    )
    BEGIN
        RAISERROR ('Продаж товарів "Яблука", "Груші", "Сливи" та "Кінза" заборонений.', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        INSERT INTO Sales (ProductId, SalePrice, Quantity, SaleDate, CustomerId, EmployeeId)
        SELECT ProductId, SalePrice, Quantity, SaleDate, CustomerId, EmployeeId
        FROM inserted;
    END
END;
--приклад заборони
INSERT INTO Sales (ProductId, SalePrice, Quantity, SaleDate, CustomerId, EmployeeId)
VALUES
    (23,  99.99, 10, '2024-03-31', 4,3);



	--При продажу товару заносити інформацію про продаж у таблицю «Історія».
CREATE TRIGGER History
ON Sales
AFTER INSERT
AS
BEGIN
    INSERT INTO PurchaseHistory (ProductId, SalePrice, Quantity, PurchaseDate, CustomerId, EmployeeId)
    SELECT 
        ProductId,
        SalePrice,
        Quantity,
        SaleDate,
        CustomerId,
        EmployeeId
    FROM inserted;
END;



