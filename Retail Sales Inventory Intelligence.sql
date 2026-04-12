-- CREATE DATABASE retail_sales_inventory;
USE retail_sales_inventory;

-- 1. customers
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  phone VARCHAR(20),
  email VARCHAR(100),
  street VARCHAR(100),
  city VARCHAR(50),
  state VARCHAR(50),
  zip_code VARCHAR(15)
);

-- 2. stores
CREATE TABLE stores (
  store_id INT PRIMARY KEY,
  store_name VARCHAR(100),
  phone VARCHAR(20),
  email VARCHAR(100),
  street VARCHAR(100),
  city VARCHAR(50),
  state VARCHAR(50),
  zip_code VARCHAR(15)
);

-- 3. staffs
CREATE TABLE staffs (
  staff_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  phone VARCHAR(20),
  active BOOLEAN,
  store_id INT,
  manager_id INT,
  FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- 4. brands
CREATE TABLE brands (
  brand_id INT PRIMARY KEY,
  brand_name VARCHAR(100)
);

-- 5. categories
CREATE TABLE categories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(100)
);

-- 6. products
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  brand_id INT,
  category_id INT,
  model_year INT,
  list_price DECIMAL(10,2),
  FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- 7. stocks
CREATE TABLE stocks (
  store_id INT,
  product_id INT,
  quantity INT,
  PRIMARY KEY (store_id, product_id),
  FOREIGN KEY (store_id) REFERENCES stores(store_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 8. orders
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_status INT,
  order_date DATE,
  required_date DATE,
  shipped_date DATE,
  store_id INT,
  staff_id INT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (store_id) REFERENCES stores(store_id),
  FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
);

-- 9. order_items
CREATE TABLE order_items (
  order_id INT,
  item_id INT,
  product_id INT,
  quantity INT,
  list_price DECIMAL(10,2),
  discount DECIMAL(4,2),
  PRIMARY KEY (order_id, item_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

select count(*) from brands;

select * from orders;


-- Enable it globally
SET GLOBAL local_infile = 1;
-- Verify
SHOW VARIABLES LIKE 'local_infile';


-- Orders with invalid customers
SELECT o.order_id
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Negative or invalid values
SELECT * FROM order_items WHERE quantity <= 0 OR list_price <= 0;

-- Null validations
SELECT * FROM customers WHERE first_name IS NULL OR email IS NULL;

-- Create SQL Views (Reusable Insights)
-- 1.Sales summary
CREATE VIEW v_sales_summary AS
SELECT 
  o.order_id,
  o.order_date,
  s.store_name,
  st.first_name AS staff_name,
  c.first_name AS customer_name,
  SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sale
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN stores s ON o.store_id = s.store_id
JOIN staffs st ON o.staff_id = st.staff_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.order_id, o.order_date, s.store_name, st.first_name, c.first_name;

-- 2.Product Performance
CREATE VIEW v_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales,
    SUM(oi.quantity) AS total_quantity,
    AVG(oi.list_price * (1 - oi.discount)) AS avg_selling_price
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN brands b ON b.brand_id = p.brand_id
JOIN categories c ON c.category_id = p.category_id
GROUP BY p.product_id, p.product_name, b.brand_name, c.category_name;

-- 3.Staff Performance
CREATE VIEW v_staff_performance AS
SELECT 
  st.staff_id,
  CONCAT(st.first_name,' ',st.last_name) AS staff_name,
  s.store_name,
  COUNT(DISTINCT o.order_id) AS total_orders,
  SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
FROM staffs st
JOIN orders o ON st.staff_id = o.staff_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN stores s ON o.store_id = s.store_id
GROUP BY st.staff_id, staff_name, s.store_name;

-- 4.Inventory Summary
CREATE VIEW v_inventory_summary AS
SELECT
    p.product_id,
    p.product_name,
    p.list_price,
    c.category_name,
    st.store_id,
    st.store_name,
    st.city,
    st.state,
    st.zip_code,
    st.phone AS store_phone,
    SUM(stk.quantity) AS stock_qty,
    SUM(stk.quantity * p.list_price) AS stock_value
FROM
    products AS p
JOIN
    stocks AS stk ON p.product_id = stk.product_id
JOIN
    stores AS st ON stk.store_id = st.store_id
JOIN
    categories AS c ON p.category_id = c.category_id
GROUP BY
    p.product_id, p.product_name, p.list_price, c.category_name,
    st.store_id, st.store_name, st.city, st.state, st.zip_code, st.phone;

-- ANALYTICAL QUERIES
-- 1. Top 5 brands by Revenue
SELECT b.brand_name, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 1) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY total_sales DESC
LIMIT 5;

-- 2. Monthly sales trend
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, 
       ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 1) AS total_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- 3. Delayed Shipment
SELECT order_id, required_date, shipped_date,
       DATEDIFF(shipped_date, required_date) AS delay_days
FROM orders
WHERE shipped_date > required_date;

-- 4. Top-performing staffs
SELECT staff_id, ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)),1) AS total_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY staff_id
ORDER BY total_sales DESC;

-- 5. Store-wise Sales & Orders
SELECT 
  st.store_name,
  ROUND(SUM(oi.list_price * oi.quantity * (1 - oi.discount)), 1) AS total_sales,
  COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN stores st ON o.store_id = st.store_id
GROUP BY st.store_name
ORDER BY total_sales DESC;

-- 6. Inventory Summary (Products in stock per store)
SELECT 
  st.store_name,
  SUM(sk.quantity) AS total_units_in_stock,
  COUNT(DISTINCT sk.product_id) AS unique_products
FROM stocks sk
JOIN stores st ON sk.store_id = st.store_id
GROUP BY st.store_name;

-- 7. Customer Order Frequency
SELECT 
  c.customer_id,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  COUNT(o.order_id) AS total_orders,
  ROUND(SUM(oi.list_price * oi.quantity * (1 - oi.discount)), 1) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 10;

DROP VIEW IF EXISTS v_inventory_summary ;


SHOW VARIABLES LIKE 'LOCAL_INFILE';
SET GLOBAL LOCAL_INFILE=1;

















