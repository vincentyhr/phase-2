CREATE DATABASE IF NOT EXISTS closeb;

USE closeb;

CREATE TABLE IF NOT EXISTS Carriers (
  CarrierID INT,
  Phone VARCHAR(20) NOT NULL,
  Email VARCHAR(50) NOT NULL,
  PRIMARY KEY (CarrierID)
);

CREATE TABLE IF NOT EXISTS Carrier_rates (
  CarrierID INT NOT NULL,
  Location VARCHAR(50) NOT NULL,
  Price DECIMAL NOT NULL,
  PRIMARY KEY (Location, CarrierID),
  -- Carrier rates updated/deleted when carrier is
  CONSTRAINT fk_1 FOREIGN KEY (CarrierID) REFERENCES Carriers(CarrierID)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Shipments (
  ShipmentID INT,
  ShippingCost DECIMAL,
  CarrierID INT,
  OrderID INT,

  -- Shipment updates if Order is updated
  -- Can't delete order if a shipment exists for it
  CONSTRAINT fk_2 FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
  -- Shipment updates if carrier id is updated
  -- Can't delete carrier if a shipment exists that they're carrying
  CONSTRAINT fk_3 FOREIGN KEY (CarrierID) REFERENCES Carriers(CarrierID)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Orders (
  OrderID INT,
  Date VARCHAR(50),
  Price DECIMAL,
  CustomerID INT,
  isReturn BOOL, -- foreign key for OrderID cannot reference two tables
  PRIMARY KEY (OrderID),

  -- Orders updates if Customer is updated
  -- If Customer is deleted, all of its orders are deleted
  CONSTRAINT fk_4 FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS OrderDetails (
  OrderID INT,
  ProductID INT,
  Quantity INT,
  PRIMARY KEY (OrderID, ProductID),
  -- If Orders is updated, Order Details is Updated
  -- If Order is deleted, Order Details is Deleted
  CONSTRAINT fk_5 FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
  -- If Product is updated, Order Details is Updated
  -- If Product is deleted, Order Details is Deleted
  CONSTRAINT fk_6 FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

-- Create the Customers table
CREATE TABLE IF NOT EXISTS Customers (
  CustomerID INT PRIMARY KEY,
  First VARCHAR(50) NOT NULL,
  Last VARCHAR(50) NOT NULL,
  City VARCHAR(100),
  ZIP VARCHAR(10),
  State VARCHAR(50),
  Street VARCHAR(100)
);

-- Create the Wish_lists table
CREATE TABLE IF NOT EXISTS Wish_lists (
  WishID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  CustomerID INT,
  -- If Customer is updated, update its wish list
  -- If Customer is deleted, delete its wish list
  CONSTRAINT fk_7 FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);


-- Create the Wish_item table
CREATE TABLE IF NOT EXISTS Wish_item (
  WishID INT,
  ProductID INT,
  PRIMARY KEY (WishID, ProductID),
  CONSTRAINT fk_8 FOREIGN KEY (WishID) REFERENCES Wish_lists(WishID),
  CONSTRAINT fk_8 FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create the Social_Media table
CREATE TABLE IF NOT EXISTS Social_Media (
  Handle VARCHAR(50) PRIMARY KEY,
  BrandID INT,
  FOREIGN KEY (BrandID) REFERENCES Brands(BrandID)
);

-- Create the Review_made table
CREATE TABLE IF NOT EXISTS Review_made (
  CustomerID INT,
  ProductID INT,
  n_stars INT,
  Comment VARCHAR(500),
  PRIMARY KEY (CustomerID, ProductID),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE IF NOT EXISTS Brands (
    BrandID INT,
    Name VARCHAR(50),
    Email VARCHAR(50),
    City VARCHAR(50),
    ZIP VARCHAR(50),
    State VARCHAR(50),
    Street VARCHAR(50),
    PRIMARY KEY (BrandID)
);

CREATE TABLE IF NOT EXISTS Products (
    Name VARCHAR(50),
    Description VARCHAR(50),
    ProductID INT,
    Price INT,
    BrandID INT,
    Category_Title VARCHAR(50),
    PRIMARY KEY (ProductID),
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID),
    FOREIGN KEY (Category_Title) REFERENCES Categories(Title)
);

CREATE TABLE IF NOT EXISTS Variants (
    ProductID INT,
    color VARCHAR(50),
    size VARCHAR(50),
    stock INT,
    PRIMARY KEY (ProductID, color, size),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE IF NOT EXISTS Categories (
    Title VARCHAR(50),
    Description VARCHAR(50),
    PRIMARY KEY (Title)
);