
USE ecommerce_analytics;

LOAD DATA LOCAL INFILE
'C:/Users/Priyanshu Tanwar/Desktop/ecommerce-city-performance-analysis/Data/Raw/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    @approved_at,
    @carrier_date,
    @delivered_date,
    @estimated_date
)
SET
    order_approved_at = NULLIF(@approved_at, ''),
    order_delivered_carrier_date = NULLIF(@carrier_date, ''),
    order_delivered_customer_date = NULLIF(@delivered_date, ''),
    order_estimated_delivery_date = NULLIF(@estimated_date, '');
