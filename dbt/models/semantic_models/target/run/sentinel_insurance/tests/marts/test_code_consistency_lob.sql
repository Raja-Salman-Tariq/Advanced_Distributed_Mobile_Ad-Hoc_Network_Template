
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Test: LOB_CODE Consistency Validation
-- Ensures all LOB_CODE values in fact/dim tables exist in dim_line_of_business
-- Uses efficient LEFT JOIN approach with sampling

WITH lob_reference AS (
    SELECT DISTINCT LOB_CODE
    FROM EKAI.demoModel_18_marts.dim_line_of_business
),

-- Sample from fct_claims (limit to 100k rows)
claims_lob AS (
    SELECT DISTINCT
        'fct_claims' AS source_table,
        LOB_CODE
    FROM EKAI.demoModel_18_marts.fct_claims
    SAMPLE BERNOULLI (100000 ROWS)
    WHERE LOB_CODE IS NOT NULL
),

-- Sample from dim_policies (limit to 50k rows)
policies_lob AS (
    SELECT DISTINCT
        'dim_policies' AS source_table,
        LOB_CODE
    FROM EKAI.demoModel_18_marts.dim_policies
    SAMPLE BERNOULLI (50000 ROWS)
    WHERE LOB_CODE IS NOT NULL
),

all_lob_codes AS (
    SELECT * FROM claims_lob
    UNION ALL
    SELECT * FROM policies_lob
),

orphaned_lob_codes AS (
    SELECT
        a.source_table,
        a.LOB_CODE
    FROM all_lob_codes a
    LEFT JOIN lob_reference r ON a.LOB_CODE = r.LOB_CODE
    WHERE r.LOB_CODE IS NULL
        AND a.LOB_CODE != 'Unclassified'  -- Allow 'Unclassified' as per BRD
)

-- This test will warn if any LOB codes don't exist in reference table
SELECT *
FROM orphaned_lob_codes
  
  
      
    ) dbt_internal_test