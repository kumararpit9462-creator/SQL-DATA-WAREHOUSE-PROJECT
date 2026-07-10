## Silver Layer ETL Stored Procedure

This stored procedure automates the loading of data from the **Bronze** layer into the **Silver** layer by performing data cleansing, validation, standardization, and transformation.

### Key Transformations
- Removes duplicate customer records.
- Trims leading and trailing spaces from text fields.
- Standardizes categorical values (e.g., Gender, Marital Status, Product Line).
- Replaces missing values with appropriate defaults.
- Validates and converts date fields using `TRY_CONVERT()`.
- Corrects invalid sales, price, and quantity calculations.
- Derives product end dates using the `LEAD()` window function.
- Cleans and standardizes ERP customer and location data.
- Truncates target tables before each load to ensure a fresh, consistent dataset.
- Logs execution time for individual table loads and the overall batch process.

This procedure serves as the core ETL process for preparing clean, validated, and analytics-ready data in the Silver layer of the data warehouse.
exec silver.load_silver 
CREATE OR ALTER PROCEDURE silver.load_silver as 
BEGIN
   DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time datetime , @batch_end_time datetime ;
   set @batch_start_time = GETDATE()
   BEGIN TRY 
        print '>> inserting into the silver layers_data cleansing and data validation , manipulation ---'
        print '----------------------------------------                             ---------------------'

        --table 1 _ bronze.crm_cust_info into silver.crm_cust_info
        set @start_time = GETDATE() ;
        PRINT '>>>TRUNCATING THE TABLE silver.crm_cust_info'
        PRINT'>>>INSERTING INTO TABLE silver.crm_cust_info '
        truncate table silver.crm_cust_info 
        INSERT INTO silver.crm_cust_info
        (cst_id , 
        cst_key ,
        cst_firstname , 
        cst_lastname ,
        cst_material_status ,
        cst_gndr ,
        cst_create_date
        )

        select cst_id , cst_key ,
        trim(cst_firstname) as cst_firstname ,                          ----DATA TRIMING _ CLEANING OF SPACES
        trim(cst_lastname) as cst_lastname ,                            ----DATA TRIMING _ CLEANING OF SPACES
        case when UPPER(TRIM(cst_material_status )) = 'S' then 'SINGLE'  
        WHEN UPPER(TRIM(cst_material_status )) = 'M' then 'MARRIED' 
        ELSE 'n/a' END AS cst_material_status                           ----NORMALIZE and standardize marital DATA TO READABLE FORM
        , 
        CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'MALE'
             WHEN UPPER(TRIM(cst_gndr)) = 'F'  THEN 'FEMALE'
             ELSE 'n/a'                                                  ---handling of missiong data ( data handling )
        END AS cst_gndr ,                                                ----NORMALIZE and standardize cst_gndr DATA TO READABLE FORM
        cst_create_date
        from bronze.crm_cust_info where 
        cst_id in 
        (
        SELECT  cst_id FROM bronze.crm_cust_info
        group by cst_id
        having count(*) = 1                                             -------rmoving duplicates ( data cleansing )
        ) and 
        cst_id is not null and cst_key is not null and cst_firstname is not null and cst_lastname is not null
        SET @end_time = getdate()
        print '>> LOAD DURATION : '  + CAST ( DATEDIFF( second , @start_time , @end_time) AS NVARCHAR ) + 'seconds'

        --table 2 bronze.crm_prd_info into silver.crm_prd_info-----------------------------------------
        set @start_time = GETDATE() 
        PRINT '>>>TRUNCATING THE TABLE silver.crm_prd_info '
        PRINT'>>>INSERTING INTO TABLE silver.crm_prd_info  '
        truncate table silver.crm_prd_info 
        INSERT INTO silver.crm_prd_info 
        (
        prd_id ,
        cat_id ,
        prd_key ,
        prd_nm ,
        prd_cost ,
        prd_line , 
        prd_start_dt ,
        prd_end_dt
        ) 


        select 
        prd_id ,
        REPLACE (substring ( prd_key , 1 , 5 ) , '-', '_' ) as cat_id ,     -----the new column is derived 
        SUBSTRING(prd_key , 7 , LEN(prd_key)) as prd_key ,                  -----extract product key
        prd_nm ,
        ISNULL(prd_cost , 0 ) AS prd_cost ,
        CASE WHEN UPPER(TRIM(prd_line)) = 'M' then 'Mountain'
             WHEN UPPER(TRIM(prd_line)) = 'R' then 'Road'
             when UPPER(TRIM(prd_line)) = 'S' then 'Other Sales'            ---- normalization of data and mapping
             when UPPER(TRIM(prd_line)) = 'T' then 'Touring' 
             ELSE 'n/a'  END AS prd_line , prd_start_dt , 
               DATEADD(
                DAY,
                -1,
                LEAD(prd_start_dt) OVER (                                   ---- data enrichment 
                    PARTITION BY prd_key
                    ORDER BY prd_start_dt
                )
            ) AS prd_end_dt
        from bronze.crm_prd_info
        SET @end_time = getdate()
        print '>> LOAD DURATION : '  + CAST ( DATEDIFF( second , @start_time , @end_time) AS NVARCHAR ) + 'seconds'



        --table 3 bronze.crm_sales_details into silver.crm_sales_details 
        set @start_time = getdate()
        PRINT '>>>TRUNCATING THE TABLE silver.crm_sales_details'
        PRINT'>>>INSERTING INTO TABLE silver.crm_sales_details '
        TRUNCATE TABLE silver.crm_sales_details
        INSERT INTO silver.crm_sales_details
        (sls_ord_num ,
        sls_prd_key  ,
        sls_cust_id   ,
        sls_order_dt,
        sls_ship_dt  ,
        sls_due_dt ,
        sls_sales  ,
        sls_quantity  ,
        sls_price 
        )


        select 
        sls_ord_num , 
        sls_prd_key ,
        sls_cust_id ,
            CASE
                WHEN sls_order_dt = '0'
                     OR sls_order_dt IS NULL
                     OR LEN(sls_order_dt) <> 8
                THEN NULL
                ELSE TRY_CONVERT(date, sls_order_dt, 112)   ------recalculate sales if original value is missing
            END AS sls_order_date ,
            CASE
                WHEN sls_ship_dt = '0'
                     OR sls_ship_dt IS NULL
                     OR LEN(sls_ship_dt) <> 8
                THEN NULL
                ELSE TRY_CONVERT(date, sls_ship_dt, 112) 
            END AS sls_ship_dt ,
            CASE
                WHEN sls_due_dt = '0'
                     OR sls_due_dt IS NULL
                     OR LEN(sls_due_dt) <> 8
                THEN NULL
                ELSE TRY_CONVERT(date, sls_due_dt, 112)
            END AS sls_due_dt 
           , 
            case 
        when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price)  --- right value derivation
        then sls_quantity * ABS(sls_price) ELSE sls_sales  end as sls_sales, 
        sls_quantity ,
        case 
        when sls_price is null or sls_sales <= 0 
        then sls_sales / NULLIF(sls_quantity , 0 ) ELSE sls_price  end as sls_price             --- right value derivation
        FROM bronze.crm_sales_details
        SET @end_time = getdate()
        print '>> LOAD DURATION : '  + CAST ( DATEDIFF( second , @start_time , @end_time) AS NVARCHAR ) + 'seconds'


        ------TABLE 4 _ BRONZE.ERP_CUST_AZ12 TO SILVER.ERP_CUST_AZ12-----------------------------------------------
        set @start_time = getdate()
        PRINT '>>>TRUNCATING THE TABLE silver.erp_cust_AZ12'
        PRINT'>>>INSERTING INTO TABLE silver.erp_cust_AZ12 '
        truncate table silver.erp_cust_AZ12
        insert into silver.erp_cust_AZ12 
        (
        cid ,
        bdate ,
        gen
        )
        select 
        case 
        when cid like  'NAS%' then substring(cid , 4 , len(cid) ) else cid  
        END as cid  ,                                                    ------remove 'NAS' PREFIX IF PRESENT ( CLEANSING )
        CASE 
        WHEN bdate < '1924-01-01' or bdate > getdate() THEN 'NULL' ELSE bdate 
        END AS bdate ,                                                   ------REMOVE VERY OLD DATA ( CLEANSING )
        case 
        when UPPER(TRIM(gen)) IN ( 'M' , 'MALE' ) THEN 'MALE'
        when UPPER(TRIM(gen)) IN ('F' , 'FEMALE') THEN 'FEMALE' ELSE 'n/a'  ---REMOVE invalid input  ( NORMALIZATION ) 
        end as gen from bronze.erp_cust_AZ12 
        SET @end_time = getdate()
        print '>> LOAD DURATION : '  + CAST ( DATEDIFF( second , @start_time , @end_time) AS NVARCHAR ) + 'seconds'


         ---TABLE 5 . BRONZE.erp_loc_a101 to silver.erp_loc_a101 ---
        set @start_time = getdate() 
        PRINT '>>>TRUNCATING THE TABLE silver.erp_LOC_A101 '
        PRINT'>>>INSERTING INTO TABLE silver.erp_LOC_A101  '
        TRUNCATE TABLE silver.erp_LOC_A101 
        INSERT INTO silver.erp_LOC_A101 
        (
        cid , cntry )



        SELECT REPLACE(cid  , '-', '') as cid ,
        case
        when TRIM(cntry) in ( 'NULL' , '') THEN 'n/a' 
        when TRIM(cntry) in ('US' , 'USA' ) then 'United States'
        WHEN TRIM(cntry) = 'DE' then 'Germany'
        else TRIM(cntry) 
        end as cntry  FROM bronze.erp_LOC_A101 
        SET @end_time = getdate()
        print '>> LOAD DURATION : '  + CAST ( DATEDIFF( second , @start_time , @end_time) AS NVARCHAR ) + 'seconds'



        -- table 6 _ ronze.erp_px_catg1v2 -------
        
        set @start_time = getdate()
        PRINT'>>>TRUNCATING THE TABLE silver.erp_PX_CATG1V2 '
        PRINT'>>>INSERTING INTO TABLE silver.erp_PX_CATG1V2  '
        truncate table  silver.erp_PX_CATG1V2 
        insert into silver.erp_PX_CATG1V2 ( id , cat , subcat , maintainance )
        select id ,
        cat ,
        subcat ,
        maintainance
        from bronze.erp_PX_CATG1V2
        SET @end_time = getdate()
        print '>> LOAD DURATION : '  + CAST ( DATEDIFF( second , @start_time , @end_time) AS NVARCHAR ) + 'seconds'
        set @batch_end_time = getdate()
         print '>> BATCH LOAD DURATION : '  + CAST ( DATEDIFF( second , @batch_start_time , @batch_end_time) AS NVARCHAR ) + 'seconds'
    END TRY 
     BEGIN CATCH
      PRINT '-------------------------------------------'
	  PRINT 'ERROR OCCURED LOADING THE BRONZE LAYER'
	  PRINT 'Error Message' + ERROR_MESSAGE() ;
	  PRINT 'Error Message'  + CAST(ERROR_NUMBER() AS NVARCHAR ) ;
	  PRINT 'Error Message' + cast(ERROR_STATE() AS NVARCHAR ) ;
	  PRINT '--------------------------------------------'
 END CATCH
END

