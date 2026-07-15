/* =============================================================================
   Script:   02_bronze_load.sql
   Purpose:  Create the Bronze layer tables (one per scraped CSV file) and bulk
             load the raw scraped data into them, exactly as it comes out of
             the Wikipedia scraper (scraper.ipynb).

   Source files (produced by scraper.ipynb):
     - tech_acompany_info.csv   -> bronze.co_info   (2025 data, 6 columns)
     - tech_company_info2.csv   -> bronze.co_info1  (2023 data, 5 columns)
     - tech_company_info3.csv   -> bronze.co_info2  (2021 data, 6 columns)

   Note: Bronze columns are intentionally left as NVARCHAR, since the raw CSV
         values still contain formatting like "$", commas, and quotes that
         need to be cleaned in the Silver layer before casting to numeric types.
   ============================================================================= */

USE Warehouse;
GO

-- =========================================================================
-- 1. DROP AND REBUILD TABLES
-- =========================================================================

-- File 1 (2025 data) Schema: 6 columns
IF OBJECT_ID('bronze.co_info', 'U') IS NOT NULL DROP TABLE bronze.co_info;
CREATE TABLE bronze.co_info (
    company      NVARCHAR(150),
    revenue      NVARCHAR(50),
    Profit       NVARCHAR(50),
    Employees    NVARCHAR(50),
    Country      NVARCHAR(150),
    Headquarters NVARCHAR(400)
);
GO

-- File 2 (2023 data) Schema: 5 columns (no Profit column in source table)
IF OBJECT_ID('bronze.co_info1', 'U') IS NOT NULL DROP TABLE bronze.co_info1;
CREATE TABLE bronze.co_info1 (
    company      NVARCHAR(150),
    revenue      NVARCHAR(50),
    Employees    NVARCHAR(50),
    Country      NVARCHAR(150),
    Headquarters NVARCHAR(400)
);
GO

-- File 3 (2021 data) Schema: 6 columns (adds revenue_per_employee instead of Profit)
IF OBJECT_ID('bronze.co_info2', 'U') IS NOT NULL DROP TABLE bronze.co_info2;
CREATE TABLE bronze.co_info2 (
    company               NVARCHAR(150),
    revenue               NVARCHAR(50),
    Employees             NVARCHAR(50),
    revenue_per_employee  NVARCHAR(50),
    Country               NVARCHAR(150),
    Headquarters          NVARCHAR(400)
);
GO


-- =========================================================================
-- 2. CLEAR AND IMPORT EVERY FILE WITH THE CORRECT WINDOWS ROW FORMAT
-- =========================================================================
-- NOTE: File paths below are local to the machine the pipeline was built on.
--       Update the file paths to match your own environment before running.

-- --- IMPORT FILE 1: 2025 data ---
TRUNCATE TABLE bronze.co_info;
BULK INSERT bronze.co_info
FROM 'F:\python pandas\tech_acompany_info.csv'
WITH (
    FIRSTROW = 2,               -- skip the CSV header row
    FORMAT = 'CSV',
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',   -- Windows-style CRLF line endings
    TABLOCK
);
GO

-- --- IMPORT FILE 2: 2023 data ---
TRUNCATE TABLE bronze.co_info1;
BULK INSERT bronze.co_info1
FROM 'F:\python pandas\tech_company_info2.csv'
WITH (
    FIRSTROW = 2,
    FORMAT = 'CSV',
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a'
    -- NOTE: TABLOCK was omitted here (unlike files 1 and 3) — add it back
    -- for consistency/performance if this is a large file.
);
GO

-- --- IMPORT FILE 3: 2021 data ---
TRUNCATE TABLE bronze.co_info2;
BULK INSERT bronze.co_info2
FROM 'F:\python pandas\tech_company_info3.csv'
WITH (
    FIRSTROW = 2,
    FORMAT = 'CSV',
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    TABLOCK
);
GO
