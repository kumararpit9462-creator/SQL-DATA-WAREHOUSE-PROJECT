/*
===============================================================================
DDL Script: Bronze Layer
===============================================================================

Purpose:
    This script creates the Bronze layer tables that serve as the raw data
    ingestion layer of the Data Warehouse. The Bronze layer stores source
    data exactly as received from the source systems without applying any
    transformations, validations, or business rules.

Objectives:
    - Create raw staging tables for CRM and ERP datasets.
    - Preserve the original structure and values of the source data.
    - Enable fast and reliable bulk data loading.
    - Establish the foundation for downstream Silver and Gold layer processing.

Note:
    The Bronze layer is intended for raw data storage only. Data cleansing,
    standardization, and business transformations are performed in the
    Silver layer.
===============================================================================
*/


USE DataWarehouse ;
--table for crm datasets

--recreating and checking if the table exists - IT CHECKS WHETHER THE TABLE EXISTS OR NOT 
IF OBJECT_ID('bronze.crm_cust_info' , 'U') IS NOT NULL 
    DROP TABLE bronze.crm_cust_info ;
create table bronze.crm_cust_info 
( 
cst_id INT ,
cst_key NVARCHAR(50) ,
cst_firstname NVARCHAR (50) ,
cst_lastname NVARCHAR (50) ,
cst_material_status NVARCHAR (50) ,
cst_gndr NVARCHAR (50) ,
cst_create_date DATE 
)


--TABLE 2
IF OBJECT_ID('bronze.crm_prd_info' , 'U') IS NOT NULL 
    DROP TABLE bronze.crm_prd_info ;
CREATE TABLE bronze.crm_prd_info
(
prd_id INT ,
prd_key NVARCHAR (50) ,
prd_nm VARCHAR (50) ,
prd_line NVARCHAR(50) ,
prd_cost NVARCHAR (50) ,
prd_start_dt DATE ,
prd_end_dt NVARCHAR (50)
)

--TABLE 3
IF OBJECT_ID('bronze.crm_sales_details' , 'U') IS NOT NULL 
    DROP TABLE bronze.crm_sales_details ;
create table bronze.crm_sales_details
( 
sls_ord_num NVARCHAR(50) ,
sls_prd_key NVARCHAR (50) ,
sls_cust_id  INT ,
sls_order_dt NVARCHAR(50) ,
sls_ship_dt NVARCHAR(50) ,
sls_due_dt NVARCHAR(50),
sls_sales INT ,
sls_quantity INT ,
sls_price INT
)

--table for erp datasets 
IF OBJECT_ID('bronze.erp_cust_AZ12' , 'U') IS NOT NULL 
    DROP TABLE bronze.erp_cust_AZ12 ;
CREATE TABLE bronze.erp_cust_AZ12
(
cid NVARCHAR (50) ,
bdate NVARCHAR (50) ,
gen NVARCHAR(50)
)

--TABLE 2
IF OBJECT_ID('bronze.erp_LOC_A101' , 'U') IS NOT NULL 
    DROP TABLE bronze.erp_LOC_A101 ;

CREATE TABLE bronze.erp_LOC_A101
(
cid NVARCHAR (50) ,
cntry VARCHAR(50)

)

--TABLE 3
IF OBJECT_ID('bronze.erp_PX_CATG1V2' , 'U') IS NOT NULL 
    DROP TABLE bronze.erp_PX_CATG1V2 ;

CREATE TABLE bronze.erp_PX_CATG1V2
(
id NVARCHAR (50) ,
cat VARCHAR(50) ,
subcat VARCHAR (50) ,
maintainance NVARCHAR (50)
)

