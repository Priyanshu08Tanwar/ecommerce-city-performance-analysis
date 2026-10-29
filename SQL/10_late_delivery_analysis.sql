-- Which states have the highest late-delivery rates?
-- Include only states with at least 100 delivered orders.

SELECT
    c.customer_state,
    COUNT(*) AS delivered_orders,
    SUM(
        CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN o.order_delivered_customer_date >
                     o.order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_delivery_percentage
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(*) >= 100
ORDER BY late_delivery_percentage DESC;


-- Monthly late delivery.
USE ecommerce_analytics;

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS purchase_month,

    COUNT(*) AS delivered_orders,

    SUM(
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_delivered_customer_date >
                     order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_delivery_percentage

FROM orders

WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL

GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')

ORDER BY purchase_month;

-- Checking whether certain customer states consistently experience more late deliveries
SELECT
    c.customer_state,
    COUNT(*) AS delivered_orders,
    SUM(
        CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN o.order_delivered_customer_date >
                     o.order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_delivery_percentage
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(*) >= 100
ORDER BY late_delivery_percentage DESC;

-- how many days late the orders actually arrive.
SELECT
    CASE
        WHEN DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        ) = 0 THEN 'Less than 1 day late'
        WHEN DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        ) BETWEEN 1 AND 3 THEN '1-3 days late'
        WHEN DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        ) BETWEEN 4 AND 7 THEN '4-7 days late'
        WHEN DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        ) BETWEEN 8 AND 14 THEN '8-14 days late'
        ELSE 'More than 14 days late'
    END AS lateness_bucket,
    COUNT(*) AS late_orders
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date > order_estimated_delivery_date
GROUP BY lateness_bucket
ORDER BY MIN(
    DATEDIFF(
        order_delivered_customer_date,
        order_estimated_delivery_date
    )
);

-- How long does delivery actually take?
SELECT
    COUNT(*) AS delivered_orders,

    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS avg_actual_delivery_days,

    ROUND(
        AVG(
            DATEDIFF(
                order_estimated_delivery_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS avg_estimated_delivery_days

FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
  
-- Calculating percentage of delivered orders that arrived early, on the estimated date, or late.
SELECT
    CASE
        WHEN order_delivered_customer_date <
             order_estimated_delivery_date
            THEN 'Early'
        WHEN order_delivered_customer_date =
             order_estimated_delivery_date
            THEN 'On time'
        ELSE 'Late'
    END AS delivery_performance,

    COUNT(*) AS total_orders,

    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*)
         FROM orders
         WHERE order_status = 'delivered'
           AND order_delivered_customer_date IS NOT NULL
           AND order_estimated_delivery_date IS NOT NULL),
        2
    ) AS percentage_of_orders

FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL

GROUP BY delivery_performance
ORDER BY total_orders DESC;

-- Delivered on the same calendered date.
SELECT
    COUNT(*) AS exactly_on_time_orders
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND DATE(order_delivered_customer_date) =
      DATE(order_estimated_delivery_date);
      
-- **Which factors are associated with longer delivery time?**
-- Comparing late delivery rates by seller state.
USE ecommerce_analytics;

SELECT
    s.seller_state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,

    COUNT(DISTINCT CASE
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date
        THEN o.order_id
    END) AS late_orders,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN o.order_id
        END)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS late_delivery_percentage

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN sellers s
    ON oi.seller_id = s.seller_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY s.seller_state

HAVING COUNT(DISTINCT o.order_id) >= 100

ORDER BY late_delivery_percentage DESC;

-- How long does delivery take by seller state?
SELECT
    s.seller_state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,

    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ),
        2
    ) AS avg_actual_delivery_days,

    ROUND(
        AVG(
            DATEDIFF(
                o.order_estimated_delivery_date,
                o.order_purchase_timestamp
            )
        ),
        2
    ) AS avg_estimated_delivery_days

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN sellers s
    ON oi.seller_id = s.seller_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY s.seller_state

HAVING COUNT(DISTINCT o.order_id) >= 100

ORDER BY avg_actual_delivery_days DESC;

-- Checking whether the seller state and customer state are the same or different, 
-- then compare late-delivery rates for those two groups.
SELECT
    CASE
        WHEN s.seller_state = c.customer_state
            THEN 'Same state'
        ELSE 'Different states'
    END AS shipping_location_type,

    COUNT(DISTINCT o.order_id) AS delivered_orders,

    COUNT(DISTINCT CASE
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date
        THEN o.order_id
    END) AS late_orders,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN o.order_id
        END)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS late_delivery_percentage

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN sellers s
    ON oi.seller_id = s.seller_id
JOIN customers c
    ON o.customer_id = c.customer_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY shipping_location_type;

-- How many days late are orders from each seller state?
SELECT
    s.seller_state,
    COUNT(DISTINCT o.order_id) AS late_orders,

    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_estimated_delivery_date
            )
        ),
        2
    ) AS avg_days_late,

    MAX(
        DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        )
    ) AS max_days_late

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN sellers s
    ON oi.seller_id = s.seller_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
  AND o.order_delivered_customer_date >
      o.order_estimated_delivery_date

GROUP BY s.seller_state

HAVING COUNT(DISTINCT o.order_id) >= 100

ORDER BY avg_days_late DESC;

-- 10 most delayed orders.
SELECT
    order_id,
    order_purchase_timestamp,
    order_estimated_delivery_date,
    order_delivered_customer_date,

    DATEDIFF(
        order_delivered_customer_date,
        order_estimated_delivery_date
    ) AS days_late

FROM orders

WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date >
      order_estimated_delivery_date

ORDER BY days_late DESC

LIMIT 10;

-- How many orders were marked delivered on 19 September 2017 and 19 September 2018.
SELECT
    DATE(order_delivered_customer_date) AS delivery_date,
    COUNT(*) AS delivered_orders,
    SUM(
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders
FROM orders
WHERE order_status = 'delivered'
  AND DATE(order_delivered_customer_date) IN (
      '2017-09-19',
      '2018-09-19'
  )
GROUP BY DATE(order_delivered_customer_date)
ORDER BY delivery_date;

-- Checking whether the 2017 cluster has a shared pattern.
SELECT
    DATE_FORMAT(
        order_purchase_timestamp,
        '%Y-%m'
    ) AS purchase_month,
    COUNT(*) AS orders_delivered_on_date,
    SUM(
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders
FROM orders
WHERE order_status = 'delivered'
  AND DATE(order_delivered_customer_date) = '2017-09-19'
GROUP BY DATE_FORMAT(
    order_purchase_timestamp,
    '%Y-%m'
)
ORDER BY purchase_month;

-- Estimated delivery dates.
SELECT
    DATE(order_estimated_delivery_date) AS estimated_delivery_date,
    COUNT(*) AS orders_delivered_on_sep_19,
    SUM(
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders
FROM orders
WHERE order_status = 'delivered'
  AND DATE(order_delivered_customer_date) = '2017-09-19'
GROUP BY DATE(order_estimated_delivery_date)
ORDER BY estimated_delivery_date;

-- Summarize the delivery delays for orders.
SELECT
    COUNT(*) AS total_orders,

    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_estimated_delivery_date
            )
        ),
        2
    ) AS avg_days_vs_estimate,

    MIN(
        DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
    ) AS minimum_days_vs_estimate,

    MAX(
        DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
    ) AS maximum_days_vs_estimate

FROM orders
WHERE order_status = 'delivered'
  AND DATE(order_delivered_customer_date) = '2017-09-19';