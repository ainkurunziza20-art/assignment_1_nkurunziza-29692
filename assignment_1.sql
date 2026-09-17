-- ============================================================
-- SUNRISE SUPERMARKET - PL/SQL ASSIGNMENT ONE
-- Student: NKURUNZIZA Aimable
-- Student ID: 29692
-- Group: I
-- DBMS: PostgreSQL
-- ============================================================

-- ============================================================
-- 1. CREATE TABLES
-- ============================================================

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER
);


-- ============================================================
-- 2. INSERT CUSTOMERS
-- ============================================================

INSERT INTO customers
(customer_id, customer_name, email, city)
VALUES
(1, 'Patrick Habimana', 'patrick.habimana@gmail.com', 'Kigali'),
(2, 'Alice Mukamana', 'alice.mukamana@gmail.com', 'Huye'),
(3, 'Samuel Niyonzima', 'samuel.niyonzima@gmail.com', 'Musanze'),
(4, 'Claudine Uwamahoro', 'claudine.uwamahoro@gmail.com', 'Kigali'),
(5, 'Eric Tuyisenge', 'eric.tuyisenge@gmail.com', 'Rubavu'),
(6, 'Grace Ingabire', 'grace.ingabire@gmail.com', 'Kigali'),
(7, 'Kevin Mugisha', 'kevin.mugisha@gmail.com', 'Muhanga');


-- ============================================================
-- 3. INSERT PRODUCTS
-- ============================================================

INSERT INTO products
(product_id, product_name, category, price)
VALUES
(1, 'Rice 5kg', 'Food', 6500.00),
(2, 'Wheat Flour 2kg', 'Food', 3000.00),
(3, 'Fresh Milk 1L', 'Dairy', 1800.00),
(4, 'Yogurt 500ml', 'Dairy', 1500.00),
(5, 'Eggs Tray', 'Eggs', 4200.00),
(6, 'Bathing Soap', 'Personal Care', 1200.00),
(7, 'Toothpaste', 'Personal Care', 2500.00),
(8, 'Cooking Oil 2L', 'Food', 7500.00);


-- ============================================================
-- 4. INSERT ORDERS
-- ============================================================

INSERT INTO orders
(order_id, customer_id, order_date)
VALUES
(101, 1, '2026-08-01'),
(102, 2, '2026-08-03'),
(103, 3, '2026-08-05'),
(104, 1, '2026-08-08'),
(105, 4, '2026-08-10'),
(106, 5, '2026-08-12'),
(107, 2, '2026-08-15'),
(108, 6, '2026-08-17'),
(109, 1, '2026-08-20'),
(110, 3, '2026-08-22'),
(111, 4, '2026-08-24'),
(112, 5, '2026-08-26'),
(113, 2, '2026-08-28'),
(114, 1, '2026-08-30'),
(115, 6, '2026-09-02');


-- ============================================================
-- 5. INSERT ORDER ITEMS
-- ============================================================

INSERT INTO order_items
(order_item_id, order_id, product_id, quantity)
VALUES
(1,  101, 1, 2),
(2,  101, 3, 2),

(3,  102, 2, 2),
(4,  102, 5, 1),

(5,  103, 8, 1),
(6,  103, 6, 2),

(7,  104, 1, 1),
(8,  104, 7, 2),

(9,  105, 3, 3),
(10, 105, 4, 2),

(11, 106, 8, 2),
(12, 106, 5, 1),

(13, 107, 1, 2),
(14, 107, 6, 3),

(15, 108, 2, 3),
(16, 108, 3, 2),

(17, 109, 8, 1),
(18, 109, 7, 1),

(19, 110, 1, 3),
(20, 110, 4, 2),

(21, 111, 5, 2),
(22, 111, 6, 2),

(23, 112, 8, 1),
(24, 112, 3, 2),

(25, 113, 2, 2),
(26, 113, 7, 1),

(27, 114, 1, 2),
(28, 114, 8, 1),

(29, 115, 4, 3),
(30, 115, 6, 2);


-- ============================================================
-- QUESTION 1
-- List every order with customer information
-- INNER JOIN
-- ============================================================

SELECT
    o.order_id,
    c.customer_name,
    c.city,
    o.order_date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date;


-- ============================================================
-- QUESTION 2
-- List every order item with product information
-- JOIN
-- ============================================================

SELECT
    oi.order_item_id,
    p.product_name,
    p.category,
    p.price,
    oi.quantity
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
ORDER BY oi.order_item_id;


-- ============================================================
-- QUESTION 3
-- Show all customers, including customers with no orders
-- LEFT JOIN
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;


-- ============================================================
-- QUESTION 4
-- Customers whose total spending is above average
-- CTE
-- ============================================================

WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_spent
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    INNER JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spent
FROM customer_totals
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM customer_totals
)
ORDER BY total_spent DESC;


-- ============================================================
-- QUESTION 5
-- Rank customers by total spending
-- RANK() WINDOW FUNCTION
-- ============================================================

SELECT
    customer_id,
    customer_name,
    total_spent,
    RANK() OVER (
        ORDER BY total_spent DESC
    ) AS spending_rank
FROM (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_spent
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    INNER JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
) AS customer_totals
ORDER BY spending_rank;


-- ============================================================
-- QUESTION 6
-- Number each customer's orders
-- ROW_NUMBER() WINDOW FUNCTION
-- ============================================================

SELECT
    customer_id,
    order_id,
    order_date,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS order_number
FROM orders
ORDER BY customer_id, order_date;


-- ============================================================
-- QUESTION 7
-- Show running total of supermarket revenue
-- WINDOW FUNCTION
-- ============================================================

SELECT
    o.order_id,
    o.order_date,
    SUM(oi.quantity * p.price) AS order_revenue,
    SUM(SUM(oi.quantity * p.price)) OVER (
        ORDER BY o.order_date, o.order_id
    ) AS running_total
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.order_id, o.order_date
ORDER BY o.order_date, o.order_id;


-- ============================================================
-- QUESTION 8
-- Find the number of days between customer orders
-- LAG() WINDOW FUNCTION
-- ============================================================

SELECT
    customer_id,
    order_id,
    order_date,
    previous_order_date,
    order_date - previous_order_date AS days_since_previous_order
FROM (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_date
    FROM orders
) AS customer_orders
WHERE previous_order_date IS NOT NULL
ORDER BY customer_id, order_date;