
USE SportStore;
GO

CREATE TRIGGER UpdateProductQuantity
ON Products
INSTEAD OF INSERT
AS
BEGIN
    -- якщо товар є додаємо до нього кількість
    UPDATE p
    SET p.Quantity = p.Quantity + i.Quantity
    FROM Products p
    JOIN inserted i ON p.ProductId = i.ProductId;
    
    -- Додаємо новий товар якого в нас ще немає
    INSERT INTO Products (Name, Category, Quantity, Cost, Manufacturer, SalePrice)
    SELECT i.Name, i.Category, i.Quantity, i.Cost, i.Manufacturer, i.SalePrice
    FROM inserted i
    WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductId = i.ProductId);
END;


CREATE TRIGGER ArchiveEmployee
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO ArchivedEmployees (EmployeeId, FullName, Position, HireDate, Salary, TerminationDate)
    SELECT EmployeeId, FullName, Position, HireDate, Salary, GETDATE() AS TerminationDate
    FROM deleted;
END;
