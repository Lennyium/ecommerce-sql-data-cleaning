
-- Monthly sales performance using a CTE and LAG()
WITH monthly_sales AS (
    SELECT
        strftime('%Y-%m', order_date) AS month,
        COUNT(*) AS total_orders,
        ROUND(
            SUM(total_amount - COALESCE(discount_amount, 0)), 2
        ) AS net_sales
    FROM orders_clean
    WHERE total_amount IS NOT NULL
    GROUP BY strftime('%Y-%m', order_date)
)
SELECT
    month,
    total_orders,
    net_sales,
    ROUND(
        net_sales - LAG(net_sales) OVER (ORDER BY month), 2
    ) AS sales_change
FROM monthly_sales
ORDER BY month;


-- Top 10 customers by net spending
SELECT
    c.full_name,
    COUNT(o.id) AS total_orders,
    ROUND(
        SUM(o.total_amount - COALESCE(o.discount_amount, 0)), 2
    ) AS net_spending
FROM customers_clean c
JOIN orders_clean o ON c.id = o.customer_id
WHERE o.total_amount IS NOT NULL
GROUP BY c.id, c.full_name
ORDER BY net_spending DESC
LIMIT 10;


-- Payment method analysis
SELECT
    payment_method,
    COUNT(*) AS total_payments,
    ROUND(AVG(transaction_fee), 2) AS avg_transaction_fee,
    ROUND(SUM(transaction_fee), 2) AS total_transaction_fees
FROM payments_clean
GROUP BY payment_method
ORDER BY total_payments DESC;


-- Annual sales performance
SELECT
    strftime('%Y', order_date) AS year,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount), 2) AS gross_sales,
    ROUND(SUM(discount_amount), 2) AS total_discounts,
    ROUND(
        SUM(total_amount - COALESCE(discount_amount, 0)), 2
    ) AS net_sales
FROM orders_clean
WHERE total_amount IS NOT NULL
GROUP BY year
ORDER BY year;


-- Monthly sales seasonality
SELECT
    strftime('%m', order_date) AS month,
    COUNT(*) AS total_orders,
    ROUND(
        SUM(total_amount - COALESCE(discount_amount, 0)), 2
    ) AS net_sales
FROM orders_clean
WHERE total_amount IS NOT NULL
GROUP BY month
ORDER BY net_sales DESC;


-- Sales by customer city
SELECT
    c.city,
    COUNT(o.id) AS total_orders,
    ROUND(
        SUM(o.total_amount - COALESCE(o.discount_amount, 0)), 2
    ) AS net_sales
FROM customers_clean c
JOIN orders_clean o ON c.id = o.customer_id
WHERE o.total_amount IS NOT NULL
GROUP BY c.city
ORDER BY net_sales DESC
LIMIT 10;


-- Orders with discounts exceeding order amounts
SELECT
    COUNT(*) AS flagged_orders,
    ROUND(SUM(discount_amount), 2) AS total_flagged_discounts
FROM orders_clean
WHERE discount_amount > total_amount
  AND total_amount IS NOT NULL;
