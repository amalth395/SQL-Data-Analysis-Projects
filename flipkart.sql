CREATE DATABASE IF NOT EXISTS flipkart_db;
USE flipkart_db;

-- Step 2: Create flipkart_orders table (Header Table)
-- ============================================
DROP TABLE IF EXISTS flipkart_details;  -- Drop child table first due to foreign key
DROP TABLE IF EXISTS flipkart_orders;   -- Then drop parent table

CREATE TABLE flipkart_orders (
    OrderID VARCHAR(20) PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    State VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    INDEX idx_customer (CustomerName),
    INDEX idx_state (State),
    INDEX idx_city (City),
    INDEX idx_order_date (OrderDate)
);

-- Step 3: Create flipkart_details table (Details Table)
-- ============================================
CREATE TABLE flipkart_details (
    DetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID VARCHAR(20) NOT NULL,
    Amount INT NOT NULL,
    Profit INT NOT NULL,
    Quantity INT NOT NULL,
    Category VARCHAR(50) NOT NULL,
    SubCategory VARCHAR(50) NOT NULL,
    PaymentMode VARCHAR(20) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES flipkart_orders(OrderID) ON DELETE CASCADE,
    INDEX idx_category (Category),
    INDEX idx_subcategory (SubCategory),
    INDEX idx_payment (PaymentMode));
    
 
 