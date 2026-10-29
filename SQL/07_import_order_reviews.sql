USE ecommerce_analytics;

LOAD DATA LOCAL INFILE
'C:/Users/Priyanshu Tanwar/Desktop/ecommerce-city-performance-analysis/Data/Raw/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
);