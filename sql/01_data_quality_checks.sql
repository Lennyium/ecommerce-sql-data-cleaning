-- Missing order amounts
SELECT COUNT(*) AS missing_order_amounts
FROM orders_raw
WHERE total_amount IS NULL;

-- Orders with discounts exceeding order amounts
SELECT COUNT(*) AS suspicious_discounts
FROM orders_clean
WHERE discount_amount > total_amount
  AND total_amount IS NOT NULL;

-- Customers with missing cities
SELECT COUNT(*) AS missing_customer_cities
FROM customers_raw
WHERE city IS NULL OR TRIM(city) = '';

-- Products with missing prices
SELECT COUNT(*) AS missing_product_prices
FROM products_raw
WHERE price IS NULL;

-- Categories with missing names
SELECT COUNT(*) AS missing_category_names
FROM categories_raw
WHERE category_name IS NULL OR TRIM(category_name) = '';

-- Payments with missing transaction fees
SELECT COUNT(*) AS missing_transaction_fees
FROM payments_clean
WHERE transaction_fee IS NULL;