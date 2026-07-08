# 📊 Modern Data Warehouse for Sales Analytics

A complete end-to-end **SQL Data Warehouse** project built using the **Medallion Architecture (Bronze, Silver, Gold)**. This project demonstrates industry-standard data warehousing practices, including data ingestion, transformation, dimensional modeling, and business analytics.

The goal of this project is to transform raw business data into a centralized, analytics-ready warehouse that enables efficient reporting and data-driven decision-making.

---

## 📌 Project Overview

Modern organizations collect data from multiple operational systems, making analysis difficult due to inconsistent formats and fragmented storage.

This project solves that problem by designing a centralized Data Warehouse that:

- Integrates multiple data sources
- Cleans and standardizes raw data
- Builds analytical data models
- Supports business intelligence and reporting
- Enables fast SQL-based analytics

---

## 🎯 Business Objectives

- Consolidate CRM and ERP data into a unified warehouse.
- Build a scalable ETL pipeline.
- Improve data quality through cleansing and standardization.
- Design a Star Schema optimized for analytical workloads.
- Generate business insights using SQL queries.

---

# 🏗️ High-Level Architecture

The project follows the **Medallion Architecture**, a modern data engineering approach that separates data into multiple quality layers.

```
                Source Systems
        +---------------------------+
        | CRM | ERP | CSV Files     |
        +-----------+---------------+
                    │
                    ▼
             Bronze Layer
      (Raw Data Ingestion)
                    │
                    ▼
             Silver Layer
   (Cleaning & Standardization)
                    │
                    ▼
              Gold Layer
   (Star Schema & Analytics)
                    │
                    ▼
       Business Intelligence
     SQL Analytics / Power BI
```

---

## 📂 Architecture Diagram

> Replace the image below after exporting your Draw.io diagram.

```markdown
![Architecture](docs/architecture.png)
```

---

# 🏛️ Data Warehouse Architecture

The warehouse is divided into three logical layers.

## 🥉 Bronze Layer

The Bronze layer stores raw data exactly as received from the source systems.

### Responsibilities

- Raw data ingestion
- Historical data preservation
- No transformations applied
- Source of truth

---

## 🥈 Silver Layer

The Silver layer improves the quality of the data.

### Responsibilities

- Remove duplicate records
- Handle missing values
- Standardize formats
- Clean invalid records
- Apply business transformation rules

---

## 🥇 Gold Layer

The Gold layer contains business-ready analytical data modeled using a **Star Schema**.

This layer is optimized for:

- Reporting
- Dashboarding
- Business Intelligence
- Data Analysis

---

# ⭐ Data Model

The analytical warehouse follows a **Star Schema** consisting of Fact and Dimension tables.

## Fact Tables

- FactSales

## Dimension Tables

- DimCustomer
- DimProduct
- DimDate
- DimLocation
- DimCategory

---

# ⚙️ ETL Pipeline

The ETL process consists of the following stages:

1. Extract raw data from CRM and ERP systems.
2. Load raw data into the Bronze layer.
3. Clean and standardize records in the Silver layer.
4. Build dimensional models in the Gold layer.
5. Execute analytical SQL queries for reporting.

---

# 📈 Business Analytics

The warehouse enables analysis of key business metrics, including:

- Sales Performance
- Customer Segmentation
- Revenue Trends
- Monthly Sales Analysis
- Product Performance
- Regional Sales
- Top Customers
- Best Selling Products

---

# 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| SQL Server | Database Management |
| T-SQL | Data Transformation |
| Data Warehousing | Centralized Analytics |
| ETL | Data Processing |
| Star Schema | Data Modeling |
| Draw.io | Architecture Diagram |
| Git | Version Control |

---

# 📁 Project Structure

```
sql-data-warehouse/

│
├── datasets/
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   ├── gold/
│   └── analytics/
│
├── docs/
│   ├── architecture.drawio
│   ├── architecture.png
│   └── data_model.png
│
├── README.md
│
└── LICENSE
```

---

# 🚀 Key Skills Demonstrated

- SQL Development
- Data Warehousing
- ETL Pipeline Design
- Data Cleaning
- Data Transformation
- Data Modeling
- Star Schema Design
- Business Analytics
- Database Design
- Query Optimization

---

# 📊 Sample Business Questions Answered

- What are the top-selling products?
- Which customers generate the highest revenue?
- What is the monthly sales trend?
- Which regions contribute the most revenue?
- Which product categories perform best?
- What is the average order value?
- Which customers have the highest purchase frequency?

---

# 📈 Future Enhancements

- Interactive Power BI Dashboard
- Incremental ETL Pipeline
- Stored Procedures
- SQL Agent Scheduling
- Data Quality Validation
- Indexing & Query Optimization
- Cloud Deployment (Azure / AWS)
- Automated Data Refresh

---

# 👨‍💻 Author

**Kumar Arpit**

Aspiring Data Analyst passionate about Data Engineering, SQL, Business Intelligence, and Analytics.

- 💼 LinkedIn: *Add your LinkedIn URL*
- 💻 GitHub: *Add your GitHub URL*

---

# ⭐ If you found this project helpful

Consider giving the repository a ⭐ to support the project and help others discover it.
