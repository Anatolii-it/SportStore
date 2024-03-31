CREATE PROCEDURE AllProd
AS
BEGIN
    SELECT * FROM Products;
END;

--проверка усі товари
EXEC AllProd

go
--продажи
CREATE PROCEDURE AllEmp
as
begin
	select * from Sales;
end;

EXEC AllEmp

go

CREATE PROCEDURE GetSal
AS
BEGIN
    SELECT Sales.SaleId, Products.Name AS ProductName, Customers.FullName AS CustomerName, Employees.FullName AS EmployeeName
    FROM Sales
    INNER JOIN Products ON Sales.ProductId = Products.ProductId
    INNER JOIN Customers ON Sales.CustomerId = Customers.CustomerId
    INNER JOIN Employees ON Sales.EmployeeId = Employees.EmployeeId;
END;

--товар  покупатель продавец
EXEC GetSal
go

CREATE PROCEDURE SalesSorted
AS
BEGIN
    SELECT Sales.SaleId, Products.Name AS ProductName, Sales.SalePrice, Customers.FullName AS CustomerName, Employees.FullName AS EmployeeName
    FROM Sales
    INNER JOIN Products ON Sales.ProductId = Products.ProductId
    INNER JOIN Customers ON Sales.CustomerId = Customers.CustomerId
    INNER JOIN Employees ON Sales.EmployeeId = Employees.EmployeeId
    ORDER BY Sales.SalePrice;
END;

--отсортовано
exec SalesSorted
go

CREATE PROCEDURE GetCategory
    @Category NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Products
    WHERE Category = @Category;
END;

EXEC GetCategory 'Footwear';
go

CREATE PROCEDURE GetTopSalesperson
AS
BEGIN
    SELECT TOP 1 Employees.EmployeeId, Employees.FullName, SUM(Sales.SalePrice) AS TotalSales
    FROM Employees
    JOIN Sales ON Employees.EmployeeId = Sales.EmployeeId
    GROUP BY Employees.EmployeeId, Employees.FullName
    ORDER BY TotalSales DESC;
END;
--самий лучш продавец
EXEC GetTopSalesperson;
go

CREATE PROCEDURE CheckProd
    @Manufacturer NVARCHAR(100),
    @Availability NVARCHAR(3) OUTPUT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Products WHERE Manufacturer = @Manufacturer)
        SET @Availability = 'yes';
    ELSE
        SET @Availability = 'no';
END;
--есть в базе
DECLARE @Result NVARCHAR(3);
EXEC CheckProd 'Nike', @Result OUTPUT;
SELECT @Result AS 'Availability';
go


CREATE PROCEDURE PopularManufacturer
AS
BEGIN
    SELECT TOP 1 p.Manufacturer, SUM(s.SalePrice) AS TotalSales
    FROM Products p
    INNER JOIN Sales s ON p.ProductId = s.ProductId
    GROUP BY p.Manufacturer
    ORDER BY TotalSales DESC;
END;

EXEC PopularManufacturer
go


