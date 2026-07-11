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
## CREATE_FACT_SALES
CREATE VIEW gold.fact_sales AS
SELECT 
sd.sls_ord_num as order_number,
pr.product_key ,
cu.customer_key ,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity,
sd.sls_price as price 
FROM silver.crm_sales_details sd
left join gold.dim_products pr 
on sd.sls_prd_key = pr.product_number 
left join gold.dim_customer cu
on sd.sls_cust_id = cu.customer_id


##CREATE_DIM_PRODUCTS    
CREATE VIEW gold.dim_products AS
-- now we wil do the table integration for the product 
--we would only require the data of the product which is still in manufacturing 
select 
row_number() over (order by pn.prd_start_dt , pn.prd_key ASC ) as product_key,
pn.prd_id as product_id ,
pn.prd_key as product_number ,
pn.cat_id as category_id,
pc.subcat as subcategory ,
pc.maintainance , 
pn.prd_nm as product_name,
pn.prd_cost as cost ,
pn.prd_line ,
pn.prd_start_dt as start_date 
from silver.crm_prd_info pn 
left join silver.erp_PX_CATG1V2 pc
on pn.cat_id = pc.id 
where prd_end_dt is null         --- filter out all the historical data 

## DIM_CUSTOMER_TABLE

---we join all the customers tables at once acc to the diagram in draw.io
CREATE VIEW gold.dim_customer as 
SELECT 
        ROW_NUMBER() OVER (ORDER BY ci.cst_id ASC) AS customer_key ,
		ci.cst_id AS customer_id,
		ci.cst_key as customer_number,
		ci.cst_firstname as first_name,
		ci.cst_lastname as last_name,
		la.cntry as country ,
		ci.cst_material_status as marital_status,
		CASE WHEN ci.cst_gndr != 'n/a' then ci.cst_gndr  
		 ELSE coalesce( ca.gen ,'n/a' ) END 
		 AS gender  ,
		ca.bdate as birth_date ,
		ci.cst_create_date as create_date
		FROM silver.crm_cust_info ci
left join 
silver.erp_cust_AZ12 ca
on ci.cst_key = ca.cid
left join 
silver.erp_LOC_A101 la
on ci.cst_key = la.cid

--- quality check on the duplicate values 
---naming should be better as per the silver layer . 
---join all the tables into one 
