-- Clean categories
DROP TABLE IF EXISTS categories_clean;

CREATE TABLE categories_clean AS
SELECT
    id,
    NULLIF(LOWER(TRIM(category_name)), '') AS category_name,
    category_description,
    average_price,
    CASE
        WHEN category_name IS NULL OR TRIM(category_name) = ''
        THEN 'Missing Category Name'
        ELSE 'Valid'
    END AS data_quality_status
FROM categories_raw;


-- Clean customers
DROP TABLE IF EXISTS customers_clean;

CREATE TABLE customers_clean AS
SELECT
    id,
    NULLIF(TRIM(full_name), '') AS full_name,
    LOWER(TRIM(email)) AS email,
    registration_date,
    COALESCE(NULLIF(TRIM(city), ''), 'Unknown') AS city
FROM customers_raw;


-- Clean orders
DROP TABLE IF EXISTS orders_clean;

CREATE TABLE orders_clean AS
SELECT
    id,
    customer_id,
    order_date,
    total_amount,
    quantity,
    discount_amount,
    CASE
        WHEN total_amount IS NULL THEN 'Missing Amount'
        WHEN discount_amount > total_amount THEN 'Review Discount'
        ELSE 'Valid'
    END AS data_quality_status
FROM orders_raw;


-- Clean products
DROP TABLE IF EXISTS products_clean;

CREATE TABLE products_clean AS
SELECT
    id,
    NULLIF(TRIM(product_name), '') AS product_name,
    category_id,
    price,
    stock_quantity,
    rating,
    CASE
        WHEN price IS NULL THEN 'Missing Price'
        ELSE 'Valid'
    END AS data_quality_status
FROM products_raw;


-- Clean payments
DROP TABLE IF EXISTS payments_clean;

CREATE TABLE payments_clean AS
SELECT
    id,
    order_id,
    NULLIF(LOWER(TRIM(payment_method)), '') AS payment_method,
    payment_date,
    transaction_fee
FROM payments_raw;