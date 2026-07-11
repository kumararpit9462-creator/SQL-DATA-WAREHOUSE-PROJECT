/*
=============================================================
Gold Layer Views
=============================================================
Purpose:
    Creates business-ready dimensional and fact views by
    integrating and modeling cleansed Silver layer data into
    a star schema for reporting and analytics.

Views Created:
    - dim_customers : Customer dimension with standardized
      demographic and geographic attributes.
    - dim_products  : Product dimension with category and
      product hierarchy information.
    - fact_sales    : Sales fact view containing transactional
      measures linked to customer and product dimensions.

Features:
    - Generates surrogate keys using window functions.
    - Joins multiple Silver layer tables to enrich data.
    - Builds a star schema optimized for BI and reporting.
    - Provides a single source of truth for analytical queries.

Author : Kumar Arpit
Project: SQL Data Warehouse Project
============================================================= */
