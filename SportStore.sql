
USE SportStore;
GO

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


CREATE TRIGGER ArchiveEmployee
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO ArchivedEmployees (EmployeeId, FullName, Position, HireDate, Salary, TerminationDate)
    SELECT EmployeeId, FullName, Position, HireDate, Salary, GETDATE() AS TerminationDate
    FROM deleted;
END;

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

	--При продажу товару заносити інформацію про продаж у
	--таблицю «Історія». Таблиця «Історія» використовується
	--для дубляжу інформації про всі продажі;
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

--друге питання якесь захмарне як на мене то потрбно закупити товар а для цього запит на склад до менеджера
CREATE TRIGGER MoveToWarehouse
ON Sales
AFTER INSERT
AS
BEGIN
    DECLARE @ProductId INT;
    DECLARE @RemainingQuantity INT;

    -- Отримуємо ідентифікатор товару та залишкову кількість після продажу з вставлених даних
    SELECT @ProductId = ProductId, @RemainingQuantity = SUM(Quantity)
    FROM inserted
    GROUP BY ProductId;
    IF @RemainingQuantity <= 5
    BEGIN
        INSERT INTO Warehouse (ProductId, Quantity)
        VALUES (@ProductId, @RemainingQuantity);
    END;
END;

UPDATE Products 
SET Quantity = Quantity - 8 
WHERE ProductId = 18;

