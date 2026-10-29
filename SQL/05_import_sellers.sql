USE ecommerce_analytics;

LOAD DATA LOCAL INFILE
'C:/Users/Priyanshu Tanwar/Desktop/ecommerce-city-performance-analysis/Data/Raw/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
);