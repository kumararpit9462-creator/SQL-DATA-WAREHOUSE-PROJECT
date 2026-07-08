/*
===============================================================================
DDL Script: Database Initialization
Project      : SQL Data Warehouse
Author       : Kumar Arpit
Description  :
    This script initializes the SQL Data Warehouse environment by:
    - Switching to the master database.
    - Dropping the existing DataWarehouse database (if it exists).
    - Recreating a fresh DataWarehouse database.
    - Creating the Bronze, Silver, and Gold schemas following the
      Medallion Architecture.

Schemas:
    Bronze : Stores raw data ingested from source systems.
    Silver : Stores cleaned, validated, and transformed data.
    Gold   : Stores business-ready data optimized for reporting and analytics.

⚠️ WARNING:
    - This script will DELETE the existing 'DataWarehouse' database if it exists.
    - All tables, schemas, data, stored procedures, views, and other database
      objects inside the database will be permanently removed.
    - The database is switched to SINGLE_USER mode with ROLLBACK IMMEDIATE,
      which forcibly disconnects all active users before deletion.
    - Ensure you have a valid backup before executing this script in a
      production or shared environment.
*/
-- we are entering into the master database first 
use master ;
go

--drop and recreate 'datawarehouse' database 
IF EXISTS ( SELECT 1 FROM sys.databases where name = 'DataWarehouse' )
begin
     alter database DataWarehouse SET SINGLE_USER WITH ROLLBACK Immediate ;
     DROP DATABASE DataWarehouse ;
END
GO

-- CREATE DATAWAREHOUSE 
CREATE DATABASE DataWarehouse ;
use DataWarehouse ;

--Create schemas 
create schema bronze ; 
go

create schema silver ;
go

create schema gold ;
go




