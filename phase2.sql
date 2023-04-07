CREATE DATABASE IF NOT EXISTS closeb;

USE closeb;


-- Create the Customers table
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  First VARCHAR(50) NOT NULL,
  Last VARCHAR(50) NOT NULL,
  City VARCHAR(100),
  ZIP VARCHAR(10),
  State VARCHAR(50),
  Street VARCHAR(100)
);

-- Create the Wish_lists table
CREATE TABLE Wish_lists (
  WishID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  CustomerID INT,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create the Products table (assuming it exists)
CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  -- Add other attributes for the Products table here
);

-- Create the Wish_item table
CREATE TABLE Wish_item (
  WishID INT,
  ProductID INT,
  PRIMARY KEY (WishID, ProductID),
  FOREIGN KEY (WishID) REFERENCES Wish_lists(WishID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create the Brands table (assuming it exists)
CREATE TABLE Brands (
  BrandID INT PRIMARY KEY,
  -- Add other attributes for the Brands table here
);

-- Create the Social_Media table
CREATE TABLE Social_Media (
  Handle VARCHAR(50) PRIMARY KEY,
  BrandID INT,
  FOREIGN KEY (BrandID) REFERENCES Brands(BrandID)
);

-- Create the Review_made table
CREATE TABLE Review_made (
  CustomerID INT,
  ProductID INT,
  n_stars INT,
  Comment VARCHAR(500),
  PRIMARY KEY (CustomerID, ProductID),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
