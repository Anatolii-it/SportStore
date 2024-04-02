CREATE DATABASE SportStore;
GO

USE SportStore;
GO

CREATE TABLE Products (
    ProductId INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    Quantity INT NOT NULL,
    Cost MONEY NOT NULL,
    Manufacturer NVARCHAR(100),
    SalePrice MONEY NOT NULL
);
GO


CREATE TABLE Employees (
    EmployeeId INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(100) NOT NULL,
    Position NVARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL,
    Salary MONEY NOT NULL
);
GO

CREATE TABLE ArchivedEmployees (
    EmployeeId INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(100) NOT NULL,
    Position NVARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL,
    Salary MONEY NOT NULL,
	TerminationDate DATE NOT NULL,
);
GO

CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Gender NVARCHAR(10) NOT NULL, 
    RegistrationDate DATE NOT NULL,
    DiscountPercent DECIMAL(5, 2),
    SubscribedToNewsletter BIT
);
GO

CREATE TABLE Sales (
    SaleId INT PRIMARY KEY IDENTITY,
    ProductId INT NOT NULL,
    SalePrice MONEY NOT NULL,
    Quantity INT NOT NULL,
    SaleDate DATE NOT NULL,
	CustomerId INT NOT NULL,
	EmployeeId INT NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(EmployeeId)
);
GO

-- історія покупок
CREATE TABLE PurchaseHistory (
    PurchaseId INT PRIMARY KEY IDENTITY,
    ProductId INT NOT NULL,
    SalePrice MONEY NOT NULL,
    Quantity INT NOT NULL,
    PurchaseDate DATE NOT NULL,
	CustomerId INT NOT NULL,
	EmployeeId INT NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
	FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(EmployeeId)
);
GO

--склад
CREATE TABLE Warehouse (
    WarehouseId INT PRIMARY KEY IDENTITY,
	ProductId INT NOT NULL,
    Quantity INT NOT NULL,
	FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);