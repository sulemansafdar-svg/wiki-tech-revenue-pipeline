/* =============================================================================
   Script:   01_init_database.sql
   Purpose:  Create the "Warehouse" database and the three medallion-architecture
             schemas (bronze, silver, gold) used throughout this project.

             - bronze : raw data, loaded as-is from the scraped CSV files
             - silver : cleaned, typed, and standardized data
             - gold   : (reserved for) final business-ready aggregated views

   WARNING:  This script DROPS the existing "Warehouse" database if it already
             exists. Only run this on a dev/test SQL Server instance.
   ============================================================================= */

USE master;
GO

-- If a "Warehouse" database already exists, force-disconnect any active
-- sessions (ROLLBACK IMMEDIATE) and drop it so we start from a clean slate
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Warehouse')
BEGIN
    ALTER DATABASE Warehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Warehouse;
END;
GO

-- Create the fresh warehouse database
CREATE DATABASE Warehouse;
GO

USE Warehouse;
GO

-- Bronze layer: raw, unprocessed data straight from source CSVs
CREATE SCHEMA bronze;
GO

-- Silver layer: cleaned and standardized data
CREATE SCHEMA silver;
GO

-- Gold layer: business-level, analysis-ready data
CREATE SCHEMA gold;
GO
