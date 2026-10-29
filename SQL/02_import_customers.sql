
LOAD DATA LOCAL INFILE
'C:/Users/Priyanshu Tanwar/Desktop/ecommerce-city-performance-analysis/Data/Raw/olist_customers_dataset.csv'
INTO TABLE ecommerce_analytics.customers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
);
