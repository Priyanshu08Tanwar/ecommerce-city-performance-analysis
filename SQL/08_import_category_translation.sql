USE ecommerce_analytics;

LOAD DATA LOCAL INFILE
'C:/Users/Priyanshu Tanwar/Desktop/ecommerce-city-performance-analysis/Data/Raw/product_category_name_translation.csv'
INTO TABLE category_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_category_name,
    product_category_name_english
);