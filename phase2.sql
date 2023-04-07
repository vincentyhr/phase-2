CREATE DATABASE IF NOT EXISTS closeb;

USE closeb;

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

CREATE TABLE IF NOT EXISTS Categories (
    Title VARCHAR(50),
    Description VARCHAR(50),
    PRIMARY KEY (Title)
);

CREATE TABLE IF NOT EXISTS Products (
    Name VARCHAR(50),
    Description VARCHAR(50),
    ProductID INT,
    Price INT,
    BrandID INT,
    Category_Title VARCHAR(50),
    PRIMARY KEY (ProductID),
    -- If Brand is updated/deleted, update/delete Product
    -- If Category is updated/deleted, update/delete Product
    CONSTRAINT fk_1 FOREIGN KEY (BrandID) REFERENCES Brands(BrandID)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    CONSTRAINT fk_2 FOREIGN KEY (Category_Title) REFERENCES Categories(Title)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Variants (
    ProductID INT,
    color VARCHAR(50),
    size VARCHAR(50),
    stock INT,
    PRIMARY KEY (ProductID, color, size),
    -- If Products is updated/deleted, update/delete the variants connected to the productID
    CONSTRAINT fk_3 FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);



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
  CONSTRAINT fk_4 FOREIGN KEY (CarrierID) REFERENCES Carriers(CarrierID)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Orders (
  OrderID INT,
  Date DATETIME DEFAULT CURRENT_TIMESTAMP,
  Price DECIMAL,
  CustomerID INT,
  isReturn BOOLEAN, -- foreign key for OrderID cannot reference two tables
  PRIMARY KEY (OrderID),

  -- Orders updates if Customer is updated
  -- If Customer is deleted, all of its orders are deleted
  CONSTRAINT fk_5 FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
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
  CONSTRAINT fk_6 FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
  -- If Product is updated, Order Details is Updated
  -- If Product is deleted, Order Details is Deleted
  CONSTRAINT fk_7 FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Shipments (
  ShipmentID INT,
  ShippingCost DECIMAL,
  CarrierID INT,
  OrderID INT,

  PRIMARY KEY (ShipmentID),

  -- Shipment updates if Order is updated
  -- Can't delete order if a shipment exists for it
  CONSTRAINT fk_8 FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
  -- Shipment updates if carrier id is updated
  -- Can't delete carrier if a shipment exists that they're carrying
  CONSTRAINT fk_9 FOREIGN KEY (CarrierID) REFERENCES Carriers(CarrierID)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
);




-- Create the Wish_lists table
CREATE TABLE IF NOT EXISTS Wish_lists (
  WishID INT,
  Name VARCHAR(100) NOT NULL,
  CustomerID INT,
  PRIMARY KEY(WishID),
  -- If Customer is updated, update its wish list
  -- If Customer is deleted, delete its wish list
  CONSTRAINT fk_10 FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);


-- Create the Wish_item table
CREATE TABLE IF NOT EXISTS Wish_item (
  WishID INT,
  ProductID INT,
  PRIMARY KEY (WishID, ProductID),

  -- If WishList is updated/deleted, update/delete Wish_item
  -- If ProductID is updated/deleted, update/delete Wish_item
  CONSTRAINT fk_11 FOREIGN KEY (WishID) REFERENCES Wish_lists(WishID)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
  CONSTRAINT fk_12 FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

-- Create the Social_Media table
CREATE TABLE IF NOT EXISTS Social_Media (
  Handle VARCHAR(50) PRIMARY KEY,
  BrandID INT,

  -- If Brand is updated/deleted, update/delete its Social Media
  CONSTRAINT fk_13 FOREIGN KEY (BrandID) REFERENCES Brands(BrandID)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

-- Create the Review_made table
CREATE TABLE IF NOT EXISTS Review_made (
  CustomerID INT,
  ProductID INT,
  n_stars INT,
  Comment VARCHAR(500),
  PRIMARY KEY (CustomerID, ProductID),
  -- If Customer is updated/deleted, update/delete review_made
  -- If Product is updated/deleted, update/delete review_made
  CONSTRAINT fk_14 FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
  CONSTRAINT fk_15 FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

-- Customers
INSERT INTO Customers(CustomerID,First,Last,City,ZIP,State,Street) VALUES (1,'Yelena','Bridgwood','Orlando',32808,'Florida','737 Forest Run Road');
INSERT INTO Customers(CustomerID,First,Last,City,ZIP,State,Street) VALUES (2,'Bren','Giamuzzo','Tucson',85720,'Arizona','84615 Rusk Trail');
INSERT INTO Customers(CustomerID,First,Last,City,ZIP,State,Street) VALUES (3,'Randolf','Tremblot','Saint Louis',63116,'Missouri','8418 Dryden Point');

-- Brands
INSERT INTO Brands(BrandID,Name,Email,City,ZIP,State,Street) VALUES (1,'Obediah O''Moylane','oomoylane0@go.com','Toledo',43656,'Ohio','9 Melby Court');
INSERT INTO Brands(BrandID,Name,Email,City,ZIP,State,Street) VALUES (2,'Hermie Manns','hmanns1@sakura.ne.jp','Inglewood',90305,'California','2081 Shopko Parkway');
INSERT INTO Brands(BrandID,Name,Email,City,ZIP,State,Street) VALUES (3,'Gabby Oosthout de Vree','goosthout2@ucsd.edu','Orlando',32835,'Florida','6 Loeprich Drive');

-- Categories
INSERT INTO Categories(Title,Description) VALUES ('Fuscia','Orange Roughy 6/8 Oz');
INSERT INTO Categories(Title,Description) VALUES ('Teal','Tomatoes - Cherry, Yellow');
INSERT INTO Categories(Title,Description) VALUES ('Aquamarine','Bread - Bagels, Plain');

-- Products
INSERT INTO Products(Name,Description,ProductID,Price,BrandID,Category_Title) VALUES ('Cheese - Le Cheve Noir','circuit',1,47,1,'Fuscia');
INSERT INTO Products(Name,Description,ProductID,Price,BrandID,Category_Title) VALUES ('Steam Pan Full Lid','benchmark',2,47,2,'Teal');
INSERT INTO Products(Name,Description,ProductID,Price,BrandID,Category_Title) VALUES ('Flower - Leather Leaf Fern','Organic',3,60,3,'Aquamarine');


-- Variants
INSERT INTO Variants(ProductID,color,size,stock) VALUES (1,'Red','3XL',1);
INSERT INTO Variants(ProductID,color,size,stock) VALUES (2,'Pink','L',43);
INSERT INTO Variants(ProductID,color,size,stock) VALUES (3,'Teal','XS',34);

-- Carriers
INSERT INTO Carriers(CarrierID,Phone,Email) VALUES (1,'801-887-3263','echasmer0@si.edu');
INSERT INTO Carriers(CarrierID,Phone,Email) VALUES (2,'415-547-0169','hinnes1@noaa.gov');
INSERT INTO Carriers(CarrierID,Phone,Email) VALUES (3,'216-184-9563','glivzey2@google.com');

-- Carrier_rates
INSERT INTO Carrier_rates(CarrierID,Location,price) VALUES (1,'935 Daystar Parkway',97);
INSERT INTO Carrier_rates(CarrierID,Location,price) VALUES (2,'8 Memorial Hill',26);
INSERT INTO Carrier_rates(CarrierID,Location,price) VALUES (3,'4031 Maple Trail',49);

-- Orders
INSERT INTO Orders(OrderID,Price,CustomerID,isReturn) VALUES (1,34,1,0);
INSERT INTO Orders(OrderID,Price,CustomerID,isReturn) VALUES (2,90,2,1);
INSERT INTO Orders(OrderID,Price,CustomerID,isReturn) VALUES (3,68,3,1);

-- OrderDetails
INSERT INTO OrderDetails(OrderID,ProductID,Quantity) VALUES (1,1,9);
INSERT INTO OrderDetails(OrderID,ProductID,Quantity) VALUES (2,2,8);
INSERT INTO OrderDetails(OrderID,ProductID,Quantity) VALUES (3,3,8);

-- Shipments
INSERT INTO Shipments(ShipmentID,ShippingCost,CarrierID,OrderID) VALUES (1,42,1,1);
INSERT INTO Shipments(ShipmentID,ShippingCost,CarrierID,OrderID) VALUES (2,70,2,2);
INSERT INTO Shipments(ShipmentID,ShippingCost,CarrierID,OrderID) VALUES (3,19,3,3);

-- Wish_lists
INSERT INTO Wish_lists(WishID,Name,CustomerID) VALUES (1,'Jaquith',1);
INSERT INTO Wish_lists(WishID,Name,CustomerID) VALUES (2,'Mufi',2);
INSERT INTO Wish_lists(WishID,Name,CustomerID) VALUES (3,'Alexina',3);

-- Wish_item
INSERT INTO Wish_item(WishID,ProductID) VALUES (1,1);
INSERT INTO Wish_item(WishID,ProductID) VALUES (2,2);
INSERT INTO Wish_item(WishID,ProductID) VALUES (3,3);

-- Social_Media
INSERT INTO Social_Media(Handle,BrandID) VALUES ('Keylex',1);
INSERT INTO Social_Media(Handle,BrandID) VALUES ('Namfix',2);
INSERT INTO Social_Media(Handle,BrandID) VALUES ('Matsoft',3);

-- Review_made
INSERT INTO Review_made(CustomerID,ProductID,n_stars,Comment) VALUES (1,'1','2','Team-oriented');
INSERT INTO Review_made(CustomerID,ProductID,n_stars,Comment) VALUES (2,'2','1','Cloned');
INSERT INTO Review_made(CustomerID,ProductID,n_stars,Comment) VALUES (3,'3','2','artificial intelligence');











