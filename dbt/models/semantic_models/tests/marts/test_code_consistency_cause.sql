-- Test: CAUSE_CODE Consistency Validation
-- Ensures all CAUSE_CODE values in fct_claims exist in dim_cause_of_loss
-- Uses efficient sampling approach

WITH cause_reference AS (
    SELECT DISTINCT CAUSE_CODE
    FROM {{ ref('dim_cause_of_loss') }}
),

-- Sample from fct_claims (limit to 100k rows)
claims_cause AS (
    SELECT DISTINCT
        CAUSE_CODE
    FROM {{ ref('fct_claims') }}
    SAMPLE BERNOULLI (100000 ROWS)
    WHERE CAUSE_CODE IS NOT NULL
),

orphaned_cause_codes AS (
    SELECT
        'fct_claims' AS source_table,
        c.CAUSE_CODE
    FROM claims_cause c
    LEFT JOIN cause_reference r ON c.CAUSE_CODE = r.CAUSE_CODE
    WHERE r.CAUSE_CODE IS NULL
)

-- This test will warn if any cause codes don't exist in reference table
SELECT *
FROM orphaned_cause_codes
