# Retail_Sales_Inventory_Analytics

## Project Overview

This project delivers an end-to-end **Retail Analytics solution** using **SQL and Power BI** to analyze sales performance, inventory health, product trends, and staff efficiency across multiple stores.

The goal is to transform raw transactional data into actionable insights that support **data-driven decision-making** in retail operations.

---

## Tools & Technologies

* **Power BI** – Dashboard development & data visualization
* **MySQL** – Data modeling, transformation, and querying
* **Power Query** – Data cleaning & transformation
* **DAX** – KPI calculations and measures
* **Excel** – Initial data preprocessing

---

##  Dataset Description

The dataset includes **9 relational tables**:

* Orders, Order_Items, Customers
* Products, Categories, Brands
* Stores, Staffs, Stocks

Total:

* **1,600+ orders**
* **4,700+ transactions**
* **300+ products**

---

## Project Workflow

### 1️. Data Cleaning (Excel)

* Handled null values and inconsistent formats
* Standardized product and category names
* Validated key relationships

### 2️. SQL Data Modeling

* Designed relational schema with primary & foreign keys
* Created optimized SQL views:

  * `v_sales_summary`
  * `v_product_performance`
  * `v_staff_performance`
  * `v_inventory_summary`

### 3️. Power BI Development

* Built interactive dashboard using:

  * KPI Cards (Sales, Orders, AOV, Growth)
  * Bar Charts (Top Products, Staff Performance)
  * Line Charts (Sales Trends)
  * Treemaps & Donuts (Category & Store Distribution)
* Implemented DAX measures for dynamic insights

---

## Dashboard Highlights

### 🔹 Key Metrics

* **Total Sales:** $7.69M
* **Total Orders:** 1,615
* **Total Quantity Sold:** 7K+
* **Low Stock Items:** 323

### 🔹 Insights

* Top 10 products contribute ~65% of total revenue
* Sales peak observed in April (seasonal trend)
* Babolim is the highest-performing city/store
* Inventory imbalance in select categories
* Top 20% staff contribute majority of sales

---

## Key Learnings

* Handling **many-to-many relationships** in Power BI
* Building efficient **SQL views for analytics**
* Writing reusable **DAX measures**
* Designing clean, business-focused dashboards

---

## Challenges Faced

* MySQL `LOAD DATA LOCAL INFILE` permission issues
* Foreign key constraint errors during data import
* Incorrect aggregations due to relationship issues
* Many-to-many relationships in Power BI

---

## Project Files

* 📌 SQL Scripts → `/sql/`
* 📌 Power BI Dashboard → `/powerbi/`
* 📌 Screenshots → `/powerbi/screenshots/`
* 📌 Documentation → `/docs/`

---

## Conclusion

This project demonstrates how raw retail data can be transformed into meaningful insights using **SQL + Power BI**, enabling better decisions in sales strategy, inventory management, and staff performance.

---

## Author

**Ritu Thakur**

Data Analyst | Power BI Developer
