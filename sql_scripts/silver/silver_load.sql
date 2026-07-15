/* =============================================================================
   Script:   04_silver_load.sql
   Purpose:  Clean and transform Bronze layer data into the Silver layer.

   Cleaning applied to every table:
     - TRIM() on company names to remove stray whitespace
     - TRY_CAST() instead of CAST() so a single bad row can't crash the whole
       load — it will just insert NULL for that value instead of erroring out
     - Strip "$" from revenue/profit figures before casting to DECIMAL
     - Strip quotes and thousands-separator commas from Employees before
       casting to INT (e.g. "1,234" -> 1234)
   ============================================================================= */

USE Warehouse;
GO

-- =========================================================================
-- 2025 DATA: bronze.co_info -> silver.company_info_2025
-- =========================================================================
TRUNCATE TABLE silver.company_info_2025;
GO

INSERT INTO silver.company_info_2025 (
    company,
    revenue_billion,
    profit_billion,
    employees,
    country,
    headquarters
)
SELECT
    TRIM(company) AS company,
    TRY_CAST(REPLACE(revenue, '$', '') AS DECIMAL(18,2)),
    TRY_CAST(REPLACE(Profit, '$', '') AS DECIMAL(18,2)),
    TRY_CAST(REPLACE(REPLACE(Employees, '"', ''), ',', '') AS INT),
    Country,
    Headquarters
FROM bronze.co_info;
GO

-- =========================================================================
-- 2023 DATA: bronze.co_info1 -> silver.company_info_2023
-- =========================================================================
TRUNCATE TABLE silver.company_info_2023;
GO

INSERT INTO silver.company_info_2023 (
    company,
    revenue_billion,
    employees,
    country,
    headquarters
)
SELECT
    TRIM(company) AS company,
    TRY_CAST(REPLACE(revenue, '$', '') AS DECIMAL(18,2)),
    TRY_CAST(REPLACE(REPLACE(Employees, '"', ''), ',', '') AS INT),
    Country,
    Headquarters
FROM bronze.co_info1;
GO

-- =========================================================================
-- 2021 DATA: bronze.co_info2 -> silver.company_info_2021
-- =========================================================================
TRUNCATE TABLE silver.company_info_2021;
GO

INSERT INTO silver.company_info_2021 (
    company,
    revenue_billion,
    employees,
    revenue_per_employee,
    country,
    headquarters
)
SELECT
    TRIM(company) AS company,
    TRY_CAST(REPLACE(revenue, '$', '') AS DECIMAL(18,2)),
    TRY_CAST(REPLACE(REPLACE(Employees, '"', ''), ',', '') AS INT),
    ROUND(TRY_CAST(REPLACE(revenue_per_employee, '$', '') AS DECIMAL(18,2)), 2),
    Country,
    Headquarters
FROM bronze.co_info2;
GO
