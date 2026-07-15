/* =============================================================================
   Script:   03_silver_tables.sql
   Purpose:  Create the Silver layer tables. These mirror the Bronze tables but
             use proper data types (DECIMAL, INT) instead of raw NVARCHAR text,
             ready to receive cleaned/cast data from the Bronze layer.

   Naming: each table is named after the revenue year it represents, since the
           three source files cover three different years (2021, 2023, 2025).
   ============================================================================= */

USE Warehouse;
GO

-- =========================================================================
-- 1. DROP AND REBUILD SILVER LAYER TABLES
-- =========================================================================

-- 2025 data (6 columns) — from bronze.co_info
IF OBJECT_ID('silver.company_info_2025', 'U') IS NOT NULL
    DROP TABLE silver.company_info_2025;
GO

CREATE TABLE silver.company_info_2025 (
    company          NVARCHAR(150),
    revenue_billion  DECIMAL(18,2),  -- precision (18,2) preserves cents/decimals
    profit_billion   DECIMAL(18,2),  -- DECIMAL instead of INT to match financial formatting
    employees        INT,            -- INT type used consistently across all tables
    country          NVARCHAR(150),
    headquarters     NVARCHAR(400)
);
GO

-- 2023 data (5 columns, no profit figure available) — from bronze.co_info1
IF OBJECT_ID('silver.company_info_2023', 'U') IS NOT NULL
    DROP TABLE silver.company_info_2023;
GO

CREATE TABLE silver.company_info_2023 (
    company          NVARCHAR(150),
    revenue_billion  DECIMAL(18,2),
    employees        INT,
    country          NVARCHAR(150),
    headquarters     NVARCHAR(400)
);
GO

-- 2021 data (6 columns, includes revenue-per-employee) — from bronze.co_info2
IF OBJECT_ID('silver.company_info_2021', 'U') IS NOT NULL
    DROP TABLE silver.company_info_2021;
GO

CREATE TABLE silver.company_info_2021 (
    company                NVARCHAR(150),
    revenue_billion        DECIMAL(18,2),
    employees              INT,
    revenue_per_employee   DECIMAL(18,5),  -- higher scale for a small per-employee figure
    country                NVARCHAR(150),
    headquarters           NVARCHAR(400)
);
GO
