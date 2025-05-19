
CREATE TABLE Cities (
    CityId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL UNIQUE,
    CreatedAt DATETIME DEFAULT GETUTCDATE()
);


CREATE TABLE Restaurants (
    RestaurantId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    CityId INT NOT NULL,
    Address NVARCHAR(200),
    Phone NVARCHAR(20),
    CreatedAt DATETIME DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Restaurants_Cities FOREIGN KEY (CityId) REFERENCES Cities(CityId)
);


CREATE TABLE MenuItems (
    MenuItemId INT PRIMARY KEY IDENTITY(1,1),
    RestaurantId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    ImageUrl NVARCHAR(500),
    IsSpecial BIT DEFAULT 0, 
    CreatedAt DATETIME DEFAULT GETUTCDATE(),
    CONSTRAINT FK_MenuItems_Restaurants FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId)
);


CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    Phone NVARCHAR(20) NOT NULL CHECK (Phone LIKE '[0-9][ *-/0-9]{7,}'), 
    Email NVARCHAR(100) NOT NULL CHECK (Email LIKE '%_@_%._%'), 
    CreatedAt DATETIME DEFAULT GETUTCDATE(),
    CONSTRAINT UQ_Customers_Email UNIQUE (Email)
);


CREATE TABLE Orders (
    OrderId INT PRIMARY KEY IDENTITY(1,1),
    RestaurantId INT NOT NULL,
    CustomerId INT NOT NULL,
    TotalPrice DECIMAL(10,2) NOT NULL CHECK (TotalPrice >= 0),
    OrderDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    CreatedAt DATETIME DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Orders_Restaurants FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);


CREATE TABLE OrderItems (
    OrderItemId INT PRIMARY KEY IDENTITY(1,1),
    OrderId INT NOT NULL,
    MenuItemId INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    CreatedAt DATETIME DEFAULT GETUTCDATE(),
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
    CONSTRAINT FK_OrderItems_MenuItems FOREIGN KEY (MenuItemId) REFERENCES MenuItems(MenuItemId)
);

CREATE INDEX IX_Restaurants_CityId ON Restaurants(CityId);
CREATE INDEX IX_MenuItems_RestaurantId ON MenuItems(RestaurantId);
CREATE INDEX IX_Orders_RestaurantId ON Orders(RestaurantId);
CREATE INDEX IX_Orders_CustomerId ON Orders(CustomerId);
CREATE INDEX IX_OrderItems_OrderId ON OrderItems(OrderId);
CREATE INDEX IX_OrderItems_MenuItemId ON OrderItems(MenuItemId);


INSERT INTO Cities (Name) VALUES
    ('New York'),
    ('Los Angeles'),
    ('Chicago');

INSERT INTO Restaurants (Name, CityId, Address, Phone) VALUES
    ('Pizza Palace', 1, '123 Broadway, NY', '212-555-0101'),
    ('Taco Haven', 1, '456 5th Ave, NY', '212-555-0102'),
    ('Sushi Spot', 2, '789 Sunset Blvd, LA', '310-555-0103'),
    ('Burger Bonanza', 3, '101 Michigan Ave, Chicago', '312-555-0104');


INSERT INTO MenuItems (RestaurantId, Name, Price, ImageUrl, IsSpecial) VALUES
    (1, 'Margherita Pizza', 12.00, '/assets/images/margherita.jpg', 1),
    (1, 'Pepperoni Pizza', 15.00, '/assets/images/pepperoni.jpg', 0),
    (2, 'Chicken Tacos', 8.50, '/assets/images/tacos.jpg', 0),
    (2, 'Beef Burrito', 10.00, '/assets/images/burrito.jpg', 0),
    (3, 'California Roll', 9.00, '/assets/images/sushi.jpg', 0),
    (3, 'Spicy Tuna Roll', 11.00, '/assets/images/tuna.jpg', 0),
    (4, 'Classic Burger', 7.50, '/assets/images/burger.jpg', 0),
    (4, 'Veggie Burger', 8.00, '/assets/images/veggie.jpg', 0);


INSERT INTO Customers (Name, Address, Phone, Email) VALUES
    ('John Doe', '123 Main St, NY', '212-555-1234', 'john.doe@email.com'),
    ('Jane Smith', '456 Oak Ave, LA', '310-555-5678', 'jane.smith@email.com');


INSERT INTO Orders (RestaurantId, CustomerId, TotalPrice, OrderDate) VALUES
    (1, 1, 27.00, '2025-05-19 20:00:00'),
    (2, 2, 18.50, '2025-05-19 21:00:00');


INSERT INTO OrderItems (OrderId, MenuItemId, Quantity, UnitPrice) VALUES
    (1, 1, 1, 12.00), 
    (1, 2, 1, 15.00),
    (2, 3, 1, 8.50), 
    (2, 4, 1, 10.00); -


CREATE VIEW VW_RestaurantsByCity AS
SELECT 
    r.RestaurantId,
    r.Name AS RestaurantName,
    c.Name AS CityName,
    r.Address,
    r.Phone
FROM Restaurants r
JOIN Cities c ON r.CityId = c.CityId;


CREATE VIEW VW_OrderDetails AS
SELECT 
    o.OrderId,
    r.Name AS RestaurantName,
    c.Name AS CustomerName,
    o.TotalPrice,
    o.OrderDate,
    mi.Name AS MenuItemName,
    oi.Quantity,
    oi.UnitPrice
FROM Orders o
JOIN Restaurants r ON o.RestaurantId = r.RestaurantId
JOIN Customers c ON o.CustomerId = c.CustomerId
JOIN OrderItems oi ON o.OrderId = oi.OrderId
JOIN MenuItems mi ON oi.MenuItemId = mi.MenuItemId;