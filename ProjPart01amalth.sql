--- STAGE 1 : Downloaded the files flipkart_db ---- 

--- STAGE 2 : Creating the Flipkart tables from the flipkart.SQL  just downloaded 
    
 use flipkart_db;
 desc flipkart_orders;
 desc flipkart_details;
 
 --- STAGE 3 : Importing the data from the CSV files of the flipkart & checking data
 
 ## flipkart_orders imported 
 
select count(*) from flipkart_orders;
 
 ## flipkart_details imported 
 
  select count(*) from flipkart_details;
  
--- STAGE 3 COMPLETED ---

--- SECTION 1: SIMPLE SQL QUERIES (10 Questions) ----
--- Focus: ORDER BY, DESC, ASC, GROUP BY, HAVING, LIMIT, OFFSET, Aggregates ---

## QUESTION 1: Latest Orders - Retrieve All Orders by Recent Date

SELECT 
    OrderID,
    OrderDate,
    CustomerName,
    State,
    City
FROM 
    flipkart_orders
ORDER BY 
    OrderDate DESC
LIMIT 10;

## QUESTION 2: Order Count by State - GROUP BY and Aggregate 

SELECT 
    State,
    COUNT(*) AS total_orders
FROM 
    flipkart_orders
GROUP BY 
    State
ORDER BY 
    total_orders ASC;
    
## QUESTION 3: Average Amount by Category - HAVING Clause Filter

SELECT 
    Category,
    AVG(Amount) AS avg_amount
FROM 
    flipkart_details
GROUP BY 
    Category
HAVING 
    AVG(Amount) > 1000;
    
## QUESTION 4: Top 5 Customers by Quantity - JOIN and Aggregate

SELECT 
    o.CustomerName,
    SUM(d.Quantity) AS total_qty
FROM 
    flipkart_orders o
INNER JOIN 
    flipkart_details d
ON 
    o.OrderID = d.OrderID
GROUP BY 
    o.CustomerName
ORDER BY 
    total_qty DESC
LIMIT 5;

## QUESTION 5: Mumbai Orders with Pagination - LIMIT and OFFSET 

SELECT 
    OrderID,
    OrderDate,
    CustomerName,
    State,
    City
FROM 
    flipkart_orders
WHERE 
    City = 'Mumbai'
ORDER BY 
    CustomerName ASC
LIMIT 10 OFFSET 5;

## QUESTION 6: Profit Range by Sub-Category - MAX and MIN Aggregates  
  
  SELECT 
    SubCategory,
    MAX(Profit) AS max_profit,
    MIN(Profit) AS min_profit
FROM 
    flipkart_details
GROUP BY 
    SubCategory
ORDER BY 
    max_profit DESC;

## QUESTION 7: Payment Mode Analysis - COUNT and HAVING Threshold 
 
 SELECT 
    PaymentMode,
    COUNT(*) AS mode_count
FROM 
    flipkart_details
GROUP BY 
    PaymentMode
HAVING 
    COUNT(*) > 50;

## QUESTION 8: State-wise Revenue by City - Multi-level Grouping 

SELECT 
    o.City,
    SUM(d.Amount) AS total_amount
FROM 
    flipkart_orders o
INNER JOIN 
    flipkart_details d
ON 
    o.OrderID = d.OrderID
WHERE 
    o.State = 'Maharashtra'
GROUP BY 
    o.City
ORDER BY 
    total_amount DESC
LIMIT 3;

## QUESTION 9: Unique City List - DISTINCT and Alphabetical Order
 
 SELECT 
    DISTINCT City
FROM 
    flipkart_orders
ORDER BY 
    City ASC
LIMIT 20;

## QUESTION 10: Average Quantity Analysis - GROUP BY with HAVING Filter 

SELECT 
    OrderID,
    AVG(Quantity) AS avg_quantity
FROM 
    flipkart_details
GROUP BY 
    OrderID
HAVING 
    AVG(Quantity) > 5
ORDER BY 
    avg_quantity DESC;


--- SECTION 2: MODERATE LEVEL SQL QUERIES (10 Questions)---
--- Focus: INNER/LEFT/RIGHT JOINs, SUBQUERIEs, IN/NOT IN, CTEs ---

## QUESTION 1: Delhi Orders with Amount - INNER JOIN

SELECT 
    o.OrderID,
    o.OrderDate,
    o.CustomerName,
    o.State,
    o.City,
    d.Amount
FROM 
    flipkart_orders o
INNER JOIN 
    flipkart_details d
ON 
    o.OrderID = d.OrderID
WHERE 
    o.City = 'Delhi'
ORDER BY 
    d.Amount DESC;

## QUESTION 2: Top State Customers - Subquery with IN

SELECT 
    CustomerName,
    State
FROM 
    flipkart_orders
WHERE 
    State IN (
        SELECT State FROM (
            SELECT 
                o.State
            FROM 
                flipkart_orders o
            INNER JOIN 
                flipkart_details d
            ON 
                o.OrderID = d.OrderID
            GROUP BY 
                o.State
            ORDER BY 
                SUM(d.Quantity) DESC
            LIMIT 3
        ) AS top_states
    );
    
    ## QUESTION 3: LEFT JOIN with Negative Profit Filter - NOT IN
    
    SELECT 
    o.OrderID,
    o.OrderDate,
    o.CustomerName,
    o.State,
    o.City,
    d.Category,
    d.Profit
FROM 
    flipkart_orders o
LEFT JOIN 
    flipkart_details d
ON 
    o.OrderID = d.OrderID
WHERE 
    d.Profit < 0
    AND d.Category NOT IN ('Electronics');


## QUESTION 4: CTE for Profit Analysis - Common Table Expression

WITH customer_profit AS (
    SELECT 
        o.CustomerName,
        SUM(d.Profit) AS total_profit
    FROM 
        flipkart_orders o
    INNER JOIN 
        flipkart_details d
    ON 
        o.OrderID = d.OrderID
    GROUP BY 
        o.CustomerName
)
SELECT 
    CustomerName,
    total_profit
FROM 
    customer_profit
WHERE 
    total_profit > (
        SELECT AVG(total_profit) FROM customer_profit
    );
    
    ## QUESTION 5: RIGHT JOIN with Quantity Filter - Subquery Exclusion

SELECT 
    d.OrderID,
    o.CustomerName,
    SUM(d.Quantity) AS total_quantity
FROM 
    flipkart_orders o
RIGHT JOIN 
    flipkart_details d
ON 
    o.OrderID = d.OrderID
WHERE 
    d.OrderID IN (
        SELECT 
            OrderID
        FROM 
            flipkart_details
        GROUP BY 
            OrderID
        HAVING 
            SUM(Quantity) >= 10
    )
GROUP BY 
    d.OrderID, o.CustomerName
ORDER BY 
    total_quantity DESC;
    
## QUESTION 6: Category Filter with JOIN - IN Subquer
    
    SELECT 
    d.OrderID,
    d.Category,
    o.City
FROM 
    flipkart_details d
INNER JOIN 
    flipkart_orders o
ON 
    d.OrderID = o.OrderID
WHERE 
    d.Category IN (
        SELECT DISTINCT Category
        FROM flipkart_details
        WHERE Category IN ('Furniture', 'Clothing')
    );

## QUESTION 7: Multi-level CTE with Subquery - State Analysis

WITH state_order_count AS (
    SELECT 
        State,
        COUNT(*) AS total_orders
    FROM 
        flipkart_orders
    GROUP BY 
        State
    HAVING 
        COUNT(*) > 20
)
SELECT 
    s.State,
    AVG(d.Amount) AS avg_amount
FROM 
    state_order_count s
INNER JOIN 
    flipkart_orders o
        ON s.State = o.State
INNER JOIN 
    flipkart_details d
        ON o.OrderID = d.OrderID
GROUP BY 
    s.State
ORDER BY 
    avg_amount DESC;
    
## QUESTION 8: NOT IN with Subquery - Amount Threshold

SELECT 
    o.CustomerName,
    o.State
FROM 
    flipkart_orders o
INNER JOIN 
    flipkart_details d
ON 
    o.OrderID = d.OrderID
WHERE 
    o.State NOT IN (
        SELECT 
            o2.State
        FROM 
            flipkart_orders o2
        INNER JOIN 
            flipkart_details d2
        ON 
            o2.OrderID = d2.OrderID
        GROUP BY 
            o2.State
        HAVING 
            SUM(d2.Amount) < 50000
    )
GROUP BY 
    o.CustomerName, o.State;

## QUESTION 9: LEFT JOIN with Electronics Filter - City Analysis 

SELECT 
    o.City,
    SUM(d.Quantity) AS total_qty
FROM 
    flipkart_orders o
LEFT JOIN 
    flipkart_details d
ON 
    o.OrderID = d.OrderID
WHERE 
    o.City IN (
        SELECT DISTINCT o2.City
        FROM flipkart_orders o2
        INNER JOIN flipkart_details d2
            ON o2.OrderID = d2.OrderID
        WHERE 
            d2.Category = 'Electronics'
    )
GROUP BY 
    o.City
ORDER BY 
    total_qty DESC;

## QUESTION 10: CTE for Top Sub-Categories - Customer Mapping

WITH top_subcategories AS (
    SELECT 
        SubCategory,
        SUM(Amount) AS total_amount
    FROM 
        flipkart_details
    GROUP BY 
        SubCategory
    ORDER BY 
        total_amount DESC
    LIMIT 5
)
SELECT 
    o.CustomerName,
    d.SubCategory
FROM 
    flipkart_orders o
INNER JOIN 
    flipkart_details d
ON 
    o.OrderID = d.OrderID
WHERE 
    d.SubCategory IN (
        SELECT SubCategory FROM top_subcategories
    )
ORDER BY 
    d.SubCategory, o.CustomerName;


--- SECTION 3: HIGH-LEVEL SQL QUERIES ---
--- Focus: Window Functions - ROW_NUMBER, RANK, DENSE_RANK with PARTITION BY ---

## QUESTION 1: ROW_NUMBER for Top Order per State
  
  WITH ranked_orders AS (
    SELECT 
        o.OrderID,
        o.State,
        d.Amount,
        ROW_NUMBER() OVER (
            PARTITION BY o.State 
            ORDER BY d.Amount DESC
        ) AS rn
    FROM 
        flipkart_orders o
    INNER JOIN 
        flipkart_details d
    ON 
        o.OrderID = d.OrderID
)
SELECT 
    OrderID,
    State,
    Amount
FROM 
    ranked_orders
WHERE 
    rn = 1
ORDER BY 
    State;

## QUESTION 2: RANK() for Top Items per Category

WITH ranked_items AS (
    SELECT 
        d.OrderID,
        d.Category,
        d.Amount,
        o.CustomerName,
        RANK() OVER (
            PARTITION BY d.Category
            ORDER BY d.Amount DESC
        ) AS rnk
    FROM 
        flipkart_details d
    INNER JOIN 
        flipkart_orders o
    ON 
        d.OrderID = o.OrderID
)
SELECT 
    OrderID,
    Category,
    Amount,
    CustomerName
FROM 
    ranked_items
WHERE 
    rnk <= 3
ORDER BY 
    Category,
    Amount DESC;

## QUESTION 3: DENSE_RANK() on Profit by City

WITH city_profit AS (
    SELECT 
        o.City,
        SUM(d.Profit) AS city_total_profit
    FROM 
        flipkart_orders o
    INNER JOIN 
        flipkart_details d
    ON 
        o.OrderID = d.OrderID
    GROUP BY 
        o.City
),
ranked_city_profit AS (
    SELECT
        City,
        city_total_profit,
        DENSE_RANK() OVER (
            ORDER BY city_total_profit DESC
        ) AS city_rank
    FROM 
        city_profit
)
SELECT 
    City,
    city_total_profit
FROM 
    ranked_city_profit
WHERE 
    city_rank <= 2
ORDER BY 
    city_total_profit DESC;

## QUESTION 4: ROW_NUMBER for First Order per Customer

WITH ordered_customer AS (
    SELECT 
        OrderID,
        CustomerName,
        OrderDate,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerName
            ORDER BY OrderDate ASC
        ) AS rn
    FROM 
        flipkart_orders
),
first_orders AS (
    SELECT 
        OrderID,
        CustomerName,
        OrderDate
    FROM 
        ordered_customer
    WHERE 
        rn = 1
)
SELECT 
    f.CustomerName,
    f.OrderID,
    f.OrderDate,
    SUM(d.Quantity) AS total_quantity
FROM 
    first_orders f
INNER JOIN 
    flipkart_details d
ON 
    f.OrderID = d.OrderID
GROUP BY 
    f.CustomerName, f.OrderID, f.OrderDate
ORDER BY 
    f.CustomerName;
    
## QUESTION 5: DENSE_RANK() on Quantity by Payment Mode 

 WITH ranked_payments AS (
    SELECT 
        d.OrderID,
        d.PaymentMode,
        d.Quantity,
        o.State,
        DENSE_RANK() OVER (
            PARTITION BY d.PaymentMode
            ORDER BY d.Quantity DESC
        ) AS qty_rank
    FROM 
        flipkart_details d
    INNER JOIN 
        flipkart_orders o
    ON 
        d.OrderID = o.OrderID
)
SELECT 
    OrderID,
    PaymentMode,
    Quantity,
    State
FROM 
    ranked_payments
WHERE 
    qty_rank = 1
ORDER BY 
    PaymentMode;


