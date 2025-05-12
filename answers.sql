-- Question 1 (Achieving 1NF)
-- Step 1: Create the original ProductDetail table (for reference)
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Step 2: Insert the sample data from the assignment
INSERT INTO ProductDetail VALUES
    (101, 'John Doe', 'Laptop, Mouse'),
    (102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
    (103, 'Emily Clark', 'Phone');

-- Step 3: Create a new table that follows 1NF
-- This table will have each product in its own row
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    PRIMARY KEY (OrderID, Product)
);

-- Step 4: Transform the data to 1NF by splitting the comma-separated products
-- In a real database system, you might use a function to split strings,

-- For OrderID 101: Split "Laptop, Mouse" into separate rows
INSERT INTO ProductDetail_1NF VALUES
    (101, 'John Doe', 'Laptop'),
    (101, 'John Doe', 'Mouse');

-- For OrderID 102: Split "Tablet, Keyboard, Mouse" into separate rows
INSERT INTO ProductDetail_1NF VALUES
    (102, 'Jane Smith', 'Tablet'),
    (102, 'Jane Smith', 'Keyboard'),
    (102, 'Jane Smith', 'Mouse');

-- For OrderID 103: Already atomic (single product), just copy
INSERT INTO ProductDetail_1NF VALUES
    (103, 'Emily Clark', 'Phone');

-- Verify the transformation by selecting all records from the new 1NF table
SELECT * FROM ProductDetail_1NF ORDER BY OrderID, Product;


-- QUESTION 2:( ACHIEVING 2NF)

-- Step 1: Create the OrderDetails table that's already in 1NF (for reference)
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)
);

-- Step 2: Insert the sample data from the assignment
INSERT INTO OrderDetails VALUES
    (101, 'John Doe', 'Laptop', 2),
    (101, 'John Doe', 'Mouse', 1),
    (102, 'Jane Smith', 'Tablet', 3),  
    (102, 'Jane Smith', 'Keyboard', 1),
    (102, 'Jane Smith', 'Mouse', 2),
    (103, 'Emily Clark', 'Phone', 1);

-- Step 3: Create 2NF-compliant tables by removing partial dependencies
-- Table 1: Contains data that depends only on OrderID (the partial key)
CREATE TABLE Orders_2NF (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Table 2: Contains data that depends on the entire composite key (OrderID, Product) 
CREATE TABLE OrderItems_2NF (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders_2NF(OrderID)
);

-- Step 4: Populate the Orders_2NF table with distinct OrderID and CustomerName pairs
INSERT INTO Orders_2NF
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 5: Populate the OrderItems_2NF table with data that depends on the entire key
INSERT INTO OrderItems_2NF
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Verify the transformation by joining the tables to recreate the original view
SELECT o.OrderID, o.CustomerName, i.Product, i.Quantity
FROM Orders_2NF o
JOIN OrderItems_2NF i ON o.OrderID = i.OrderID
ORDER BY o.OrderID, i.Product;
