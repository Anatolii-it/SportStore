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

CREATE TABLE Sales (
    SaleId INT PRIMARY KEY IDENTITY,
    ProductId INT NOT NULL,
    SalePrice MONEY NOT NULL,
    Quantity INT NOT NULL,
    SaleDate DATE NOT NULL,
    SellerName NVARCHAR(100) NOT NULL,
    CustomerName NVARCHAR(100),
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
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

CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Gender NVARCHAR(10) NOT NULL, 
    OrderHistory NVARCHAR(MAX),
    DiscountPercent DECIMAL(5, 2),
    SubscribedToNewsletter BIT
);
GO

CREATE TABLE PurchaseHistory (
    PurchaseId INT PRIMARY KEY IDENTITY,
    ProductId INT NOT NULL,
    SalePrice MONEY NOT NULL,
    Quantity INT NOT NULL,
    PurchaseDate DATE NOT NULL,
    CustomerName NVARCHAR(100) NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);
GO