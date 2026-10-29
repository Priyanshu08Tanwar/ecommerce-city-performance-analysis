# E-Commerce City & Product Performance Analytics

## Project Overview

This project analyzes e-commerce data to understand sales performance, product categories, geographic trends, delivery reliability, and customer satisfaction.

Using SQL for data analysis and Power BI for visualization, the project aims to turn raw transactional data into actionable business insights.

## Tools & Technologies

- **MySQL** — data querying, analysis, joins, aggregations, and business metrics
- **Microsoft Power BI** — interactive dashboards and data visualization
- **Git & GitHub** — version control and project documentation

## Dataset

This project uses the **Brazilian E-Commerce Public Dataset by Olist**, containing order, customer, product, seller, payment, and review information.

The raw dataset is excluded from version control to keep the GitHub repository lightweight.

## Business Questions

The analysis explores questions such as:

1. Which cities and product categories generate the most revenue?
2. How does sales performance vary over time?
3. Which product categories perform best and worst?
4. How frequently are orders delivered late?
5. Which customer and seller locations have higher late-delivery rates?
6. How does delivery performance relate to customer review scores?
7. What business opportunities can be identified from these patterns?

## Key Findings So Far

- **Late-delivery rate:** 8.11% among delivered orders with available delivery and estimated delivery dates.
- **Customer satisfaction:** Orders delivered late have a lower average review score than orders delivered early or on time.
- **Delivery analysis:** Monthly trends and geographic comparisons are being used to investigate delivery performance.

*Findings will be expanded as the analysis and dashboard develop.*

## Project Structure

```text
ecommerce-city-performance-analysis/
├── Dashboard/
│   └── Ecommerce_performance_analysis.pbix
├── Data/
│   └── Raw/                  # Excluded from Git
├── Docs/
├── Reports/
├── SQL/
│   ├── 00_create_database.sql
│   ├── 01_import_orders.sql
│   ├── 02_import_customers.sql
│   ├── 03_import_order_items.sql
│   ├── 04_import_products.sql
│   ├── 05_import_sellers.sql
│   ├── 06_import_order_payments.sql
│   ├── 07_import_order_reviews.sql
│   ├── 08_import_category_translation.sql
│   ├── 09_business_analysis.sql
│   ├── 10_late_delivery_analysis.sql
│   ├── 11_review_data_quality.sql
│   └── 12_create_city_revenue_view.sql
├── .gitignore
└── README.md
```

## Dashboard Preview

The Power BI dashboard summarizes order volume, delivery performance, and customer satisfaction. A dashboard screenshot will be added here as the report develops.

## How to Explore the Project

1. Browse the SQL scripts in the `SQL/` folder to understand the analysis.
2. Open the Power BI report in the `Dashboard/` folder using Microsoft Power BI Desktop.
3. Review the dashboard and findings to understand the business implications.

## Future Improvements

- Expand city and product category analysis.
- Improve dashboard layout, filtering, and interactive exploration.
- Add recommendations supported by the analysis.
- Document additional findings and data-quality limitations.

---

**Project status:** In progress
