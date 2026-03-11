-- =====================================
-- SQL SHOP DATABASE PROJECT
-- Author: Kirill Zakharenkov
-- =====================================

-- =====================
-- 1. CREATE DATABASE
-- =====================

    CREATE DATABASE shop;

-- =====================
-- 2. CREATE TABLES
-- =====================

    CREATE TABLE users ( 
    id SERIAL PRIMARY KEY, 
    name VARCHAR(50), 
    email VARCHAR(100) UNIQUE, 
    created_at TIMESTAMP DEFAULT NOW() 
    );
-- =====================
    CREATE TABLE products ( 
    id SERIAL PRIMARY KEY, 
    title VARCHAR(100), 
    price DECIMAL, 
    stock INT, 
    is_active BOOLEAN DEFAULT TRUE 
    );
-- =====================
    CREATE TABLE orders ( 
    id SERIAL PRIMARY KEY, 
    user_id INT REFERENCES users(id), 
    created_at TIMESTAMP DEFAULT NOW(), status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PAID', 'SHIPPED')) 
    );
-- =====================
    CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id),
    product_id INT REFERENCES products(id), 
    quantity INT,
    price_at_time DECIMAL DEFAULT 100 
    );

-- =====================
-- 3. INSERT SAMPLE DATA
-- =====================

    INSERT INTO users (name, email) VALUES
    ('John', 'john@gmail.com'),
    ('Alex', 'alex@gmail.com'),
    ('Sam', 'sam@gmail.com'),
    ('Cody', 'cody@gmail.com'),
    ('Zayn', 'zayn@gmail.com');
-- =====================
    INSERT INTO products (title, price, stock) VALUES 
    ('Roses', 12, 500), 
    ('Tulips', 15, 234), 
    ('Lilies', 14, 120), 
    ('Chrysanthemum', 16, 90), 
    ('Carnations', 8, 30), 
    ('Sunflowers', 18, 60), 
    ('Peonies', 20, 100), 
    ('Orchids', 30, 700), 
    ('Hydrangeas', 19, 1), 
    ('Daisies', 5, 499);
 -- =====================
    INSERT INTO orders (user_id, status) VALUES
    (1, 'PAID'),
    (1, 'SHIPPED'),
    (2, 'PENDING'),
    (3, 'SHIPPED'),
    (3, 'PAID'),
    (4, 'PENDING'),
    (4, 'PAID'),
    (5, 'SHIPPED'),
    (5, 'PENDING');
-- =====================
    INSERT INTO order_items (order_id, product_id, quantity, price_at_time) VALUES
    (1, 10, 10, 5),
    (2, 9, 1, 19),
    (8, 8, 100, 30),
    (3, 3, 10, 14),
    (5, 6, 60, 18);

-- =====================
-- 4. ANALYTICAL QUERIES
-- =====================
-- 4.1 Show all orders with user name
-- This query joins users and orders to see which user made which order
    SELECT users.name AS user_name, orders.id AS order_id, orders.status
    FROM users
    JOIN orders ON users.id = orders.user_id
    ORDER BY orders.id;

-- 4.2 Show products in each order
-- This joins order_items with orders and products to display all products in each order
    SELECT orders.id AS order_id, products.title AS product_title, order_items.quantity, order_items.price_at_time
    FROM order_items
    JOIN orders ON order_items.order_id = orders.id
    JOIN products ON order_items.product_id = products.id
    ORDER BY orders.id;

-- 4.3 Calculate total sum of each order
-- This sums the price * quantity for each order to get the total order value
    SELECT orders.id AS order_id, SUM(order_items.quantity * order_items.price_at_time) AS total_order_amount
    FROM orders
    JOIN order_items ON orders.id = order_items.order_id
    GROUP BY orders.id
    ORDER BY orders.id;

-- 4.4 Find the user who spent the most money
-- Aggregates total spending per user and returns the top spender
    SELECT users.name AS top_spender, SUM(order_items.quantity * order_items.price_at_time) AS total_spent
    FROM users
    JOIN orders ON users.id = orders.user_id
    JOIN order_items ON order_items.order_id = orders.id
    GROUP BY users.name
    ORDER BY total_spent DESC
    LIMIT 1;

-- 4.5 Show only active products
-- Filters products to show only those that are currently active
    SELECT * FROM products
    WHERE is_active = TRUE;

-- 4.6 Find products with stock less than 5
-- Displays products that are nearly out of stock
    SELECT title, stock
    FROM products
    WHERE stock < 5
    ORDER BY stock ASC;

-- 4.7 Show users without orders
-- Finds users who have not made any orders yet using LEFT JOIN
    SELECT users.name
    FROM users
    LEFT JOIN orders ON users.id = orders.user_id
    WHERE orders.id IS NULL;