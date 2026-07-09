/*
===============================================================================
Stored Procedure: Load Bronze Layer
===============================================================================

Purpose:
    This stored procedure automates the data ingestion process for the Bronze
    layer of the Data Warehouse. It truncates the existing Bronze tables and
    reloads fresh data from the source CSV files using SQL Server's
    BULK INSERT command.

Process:
    - Truncate existing Bronze layer tables.
    - Load raw CRM and ERP datasets from CSV files.
    - Preserve source data without applying transformations.
    - Log the loading process and report any errors encountered.

Benefits:
    - Enables repeatable and consistent data loading.
    - Prevents duplicate records by clearing existing data before each load.
    - Supports efficient bulk ingestion for large datasets.
    - Serves as the first step of the ETL pipeline before Silver layer
      transformations.

Source Files:
    - source_crm/
        • cust_info.csv
        • prd_info.csv
        • sales_details.csv
    - source_erp/
        • CUST_AZ12.csv
        • LOC_A101.csv
        • PX_CATG1V2.csv

Warning:
    - This procedure permanently removes all existing data from the Bronze
      layer before loading new records.
    - Execute only after verifying that the source CSV files are available
      and their file paths are correct.
    - Ensure no other processes are using the Bronze tables during execution.

===============================================================================
*/

-- THIS CREATES A PROCEDURE FOR THE WHOLE PROCESS AT ONCE ONLY FOREVER ( CHECK DATAWAREHOUSE>> PROGRAMIBILITY >> FUNCTIONS )
CREATE OR ALTER PROCEDURE  bronze.load_bronze AS           
BEGIN  
    DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time datetime , @batch_end_time datetime ;
 BEGIN TRY
			PRINT '=======================================================' ;
			PRINT 'LOADING BRONZE LAYER' ;
			PRINT '=======================================================' ;



			-- WE WILL BULK INSERT ALL THE SIX FILES HERE 
			--CRM DATABASES

			PRINT '-------------------------------------------------------' ;
			PRINT 'LOADING CRM TABLES' ;
			PRINT '-------------------------------------------------------' ;
			set @batch_start_time = getdate() ;
			SET @start_time = getdate() ;
			PRINT '>>TRUNCATING CUST_INFO TABLE' ;
			PRINT '>>LOADING CUST_INFO TABLE' ;
			--TABLE 1 
			TRUNCATE TABLE bronze.crm_cust_info ; -- THIS DELETES THE WHOLE TABLE SO THAT IT GETS LOADED AGAIN 
			BULK INSERT bronze.crm_cust_info FROM 
			'C:\Users\kumar\OneDrive\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			WITH 
			(
			FIRSTROW = 2 ,                --THIS SKIPS THE FIRST ROW OF THE FILE ; SINCE THE DATASET STARTS FROM THE SECOND ROW 
			FIELDTERMINATOR = ',' ,       -- THIS TELLS THE SQL ABOUT THE SEPARATOR IN THE FILE (E.G. - ',' , '#' , '$' etc. )
			TABLOCK                       -- THIS LOCKS THE TABLE 
			)
            SET @end_time = getdate() ;
            print '>> LOAD DURATION : '  + CAST ( DATEDIFF( second , @start_time , @end_time) AS NVARCHAR ) + 'seconds'
			PRINT '>>TRUNCATING CRM_PRD TABLE' ;
			PRINT '>>LOADING CRM_PRD TABLE' ;




			--TABLE 2 
			set @start_time = getdate()
			TRUNCATE TABLE bronze.crm_prd_info  ;
			BULK INSERT bronze.crm_prd_info FROM 
			'C:\Users\kumar\OneDrive\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			WITH 
			(
			FIRSTROW = 2 ,                --THIS SKIPS THE FIRST ROW OF THE FILE ; SINCE THE DATASET STARTS FROM THE SECOND ROW 
			FIELDTERMINATOR = ',' ,       -- THIS TELLS THE SQL ABOUT THE SEPARATOR IN THE FILE (E.G. - ',' , '#' , '$' etc. )
			TABLOCK                       -- THIS LOCKS THE TABLE 
			) ;
            SET @end_time = getdate() ;
            print '>> LOAD DURATION : '  + CAST ( DATEDIFF( second , @start_time , @end_time) AS NVARCHAR ) + 'seconds' ;
			PRINT  '---------------------------------------------------------------------------------------------------' ;


          
			PRINT '>>>>truncating and loading crm_sales_table';
			PRINT '-------------------------------------------------------' ;



			--TABLE 3 
			set @start_time = getdate()
			TRUNCATE TABLE bronze.crm_sales_details ;
			BULK INSERT bronze.crm_sales_details FROM 
			'C:\Users\kumar\OneDrive\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			WITH 
			(
			FIRSTROW = 2 ,                --THIS SKIPS THE FIRST ROW OF THE FILE ; SINCE THE DATASET STARTS FROM THE SECOND ROW 
			FIELDTERMINATOR = ',' ,       -- THIS TELLS THE SQL ABOUT THE SEPARATOR IN THE FILE (E.G. - ',' , '#' , '$' etc. )
			TABLOCK                       -- THIS LOCKS THE TABLE 
			)
			SET @end_time = getdate() ;
            print '>> LOAD DURATION : '  + CAST ( DATEDIFF( second , @start_time , @end_time) AS NVARCHAR ) + 'seconds' ;
			print '----------------------------------------------------------------------------------------------------'
			--ERP DATABASES 




			
			PRINT 'LOADING ERP_DATABASE'  ;
			PRINT '------------------------------------------------------ ' ;
            
			--TABLE 1-- 
			PRINT '>>>>>>TRUNCATING AND LOADING erp_cust_az12'  ;
			set @start_time = getdate()
            TRUNCATE TABLE bronze.erp_cust_AZ12 ;
			BULK INSERT bronze.erp_cust_AZ12 FROM 
			'C:\Users\kumar\OneDrive\Desktop\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
			WITH 
			(
			FIRSTROW = 2 ,                --THIS SKIPS THE FIRST ROW OF THE FILE ; SINCE THE DATASET STARTS FROM THE SECOND ROW 
			FIELDTERMINATOR = ',' ,       -- THIS TELLS THE SQL ABOUT THE SEPARATOR IN THE FILE (E.G. - ',' , '#' , '$' etc. )
			TABLOCK                       -- THIS LOCKS THE TABLE 
			)
			SET @end_time = getdate() ;
            print '>> LOAD DURATION : '  + CAST ( DATEDIFF( second , @start_time , @end_time) AS NVARCHAR ) + 'seconds';
			print '----------------------------------------------------------------------------------------------------'




			--TABLE 2 
			PRINT '>>>>>>TRUNCATING AND LOADING ERP_LOC_A101 '  ;
			SET @start_time = GETDATE() ;
		    TRUNCATE TABLE  bronze.erp_LOC_A101  ;
			BULK INSERT bronze.erp_LOC_A101  FROM 
			'C:\Users\kumar\OneDrive\Desktop\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
			WITH 
			(
			FIRSTROW = 2 ,                --THIS SKIPS THE FIRST ROW OF THE FILE ; SINCE THE DATASET STARTS FROM THE SECOND ROW 
			FIELDTERMINATOR = ',' ,       -- THIS TELLS THE SQL ABOUT THE SEPARATOR IN THE FILE (E.G. - ',' , '#' , '$' etc. )
			TABLOCK                       -- THIS LOCKS THE TABLE 
			)
			SET @end_time = getdate() ;
            print '>> LOAD DURATION : '  + CAST ( DATEDIFF( second , @start_time , @end_time) AS NVARCHAR ) + 'seconds' ;
			print '----------------------------------------------------------------------------------------------------'

            --TABLE 3
			PRINT 'TRUNCATING AND LOADING THE erp_px_catg1v2 table '  ;
		    set @start_time = GETDATE() ;
		    TRUNCATE TABLE bronze.erp_PX_CATG1V2 ;
			BULK INSERT bronze.erp_PX_CATG1V2 FROM 
			'C:\Users\kumar\OneDrive\Desktop\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
			WITH 
			(
			FIRSTROW = 2 ,                --THIS SKIPS THE FIRST ROW OF THE FILE ; SINCE THE DATASET STARTS FROM THE SECOND ROW 
			FIELDTERMINATOR = ',' ,       -- THIS TELLS THE SQL ABOUT THE SEPARATOR IN THE FILE (E.G. - ',' , '#' , '$' etc. )
			TABLOCK                       -- THIS LOCKS THE TABLE 
			)
			SET @end_time = getdate() ;
			set @batch_end_time = getdate() ;
			print '>>batch load duration ' + cast(datediff( second , @batch_start_time , @batch_end_time ) as nvarchar ) + 'seconds' ;
            print '>> LOAD DURATION : '  + CAST ( DATEDIFF( second , @start_time , @end_time) AS NVARCHAR ) + 'seconds' ;
			print '----------------------------------------------------------------------------------------------------'
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




