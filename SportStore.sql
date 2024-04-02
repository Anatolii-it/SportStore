
--Домашнє завдання № 3

--1 
CREATE PROCEDURE GetAllProducts
AS
BEGIN
    SELECT *
    FROM Products;
END;

--перевірка 
exec GetAllProducts;

--2
CREATE PROCEDURE Category
    @Category NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Products
    WHERE Category = @Category;
END;

--перевірка
exec Category 'Sports Equipment';

-- 3 by Phone
CREATE PROCEDURE GetTop3OldestCustomers
AS
BEGIN
    SELECT TOP 3 *
    FROM Customers
    ORDER BY RegistrationDate ASC; 
END;

EXEC GetTop3OldestCustomers;



-- 4
CREATE PROCEDURE TopSalesperson
AS
BEGIN
    SELECT TOP 1
        Employees.FullName AS SalespersonName,
        SUM(Sales.SalePrice) AS TotalSales
    FROM Sales
    INNER JOIN Employees ON Employees.EmployeeId = Employees.EmployeeId
    GROUP BY Employees.FullName
    ORDER BY TotalSales DESC;
END;

--перевірка
exec TopSalesperson

-- 5
CREATE PROCEDURE CheckManufacturer
    @Manufacturer NVARCHAR(100)
AS
BEGIN
    DECLARE @Availability NVARCHAR(3);

    IF EXISTS (
        SELECT 1
        FROM Products
        WHERE Manufacturer = @Manufacturer
    )
        SET @Availability = 'yes';
    ELSE
        SET @Availability = 'no';

    SELECT @Availability AS Availability;
END;

-- перевірка
exec CheckManufacturer 'Adidas';

-- 6
CREATE PROCEDURE TopManufacturer
AS
BEGIN
    SELECT TOP 1
        Products.Manufacturer AS TopManufacturer,
        SUM(Sales.SalePrice) AS TotalSales
    FROM Sales
    INNER JOIN Products ON Sales.ProductId = Products.ProductId
    GROUP BY Products.Manufacturer
    ORDER BY TotalSales DESC;
END;

--перевірка
exec TopManufacturer



-- 7 RegistrationDate немає в базі тому за номером телефона
CREATE PROCEDURE DeleteCustomersRegisteredAfterDate
    @RegistrationDate DATE
AS
BEGIN
    DECLARE @DeletedCount INT;

    DELETE FROM Customers
    WHERE RegistrationDate > @RegistrationDate;
    SET @DeletedCount = @@ROWCOUNT;
    SELECT @DeletedCount AS DeletedCount;
END;

-- перевірка
exec DeleteCustomersRegisteredAfterDate '2023-01-01';
