USE ecommerce_analytics;

-- Checking for duplicate records.
SELECT
    COUNT(*) AS total_review_records,
    COUNT(DISTINCT review_id) AS unique_review_ids,
    COUNT(DISTINCT order_id) AS unique_orders_reviewed
FROM order_reviews;

-- Inspecting duplicate review IDs.
SELECT
    review_id,
    COUNT(*) AS record_count
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC
LIMIT 10;

-- Inspecting a duplicate review
SELECT *
FROM ecommerce_analytics.order_reviews
WHERE review_id = 'c444278834184f72b1484dfe47de7f97';

-- Checking whether repeated review IDs have different scores.
SELECT
    review_id,
    COUNT(*) AS record_count,
    COUNT(DISTINCT review_score) AS distinct_scores,
    COUNT(DISTINCT order_id) AS distinct_orders
FROM ecommerce_analytics.order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY distinct_scores DESC, record_count DESC
LIMIT 10;

-- Fixing our customer satisfaction analysis.
USE ecommerce_analytics;

WITH reviews_per_order AS (
    SELECT
        order_id,
        AVG(review_score) AS average_review_score
    FROM order_reviews
    GROUP BY order_id
),
delivery_per_order AS (
    SELECT
        order_id,
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN 'Late'
            ELSE 'On time or early'
        END AS delivery_status
    FROM orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
      AND order_estimated_delivery_date IS NOT NULL
)
SELECT
    d.delivery_status,
    COUNT(*) AS orders_reviewed,
    ROUND(AVG(r.average_review_score), 2) AS average_review_score
FROM delivery_per_order d
JOIN reviews_per_order r
    ON d.order_id = r.order_id
GROUP BY d.delivery_status;