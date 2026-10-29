USE ecommerce_analytics;

CREATE OR REPLACE VIEW vw_city_revenue AS
SELECT
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS freight_revenue,
    ROUND(SUM(oi.price + oi.freight_value), 2)
        AS total_value_including_freight
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_city,
    c.customer_state;
    
    
    SELECT *
FROM vw_city_revenue
ORDER BY product_revenue DESC
LIMIT 10;