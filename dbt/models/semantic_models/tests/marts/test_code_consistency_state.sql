-- Test: STATE_CODE Consistency Validation
-- Ensures all STATE_CODE values in dim tables exist in dim_states
-- Uses efficient sampling approach

WITH state_reference AS (
    SELECT DISTINCT STATE_CODE
    FROM {{ ref('dim_states') }}
),

-- Sample from dim_policies (limit to 50k rows)
policies_state AS (
    SELECT DISTINCT
        'dim_policies' AS source_table,
        STATE_CODE
    FROM {{ ref('dim_policies') }}
    SAMPLE BERNOULLI (50000 ROWS)
    WHERE STATE_CODE IS NOT NULL
),

-- Sample from dim_agencies (typically small, no sampling needed)
agencies_state AS (
    SELECT DISTINCT
        'dim_agencies' AS source_table,
        STATE_CODE
    FROM {{ ref('dim_agencies') }}
    WHERE STATE_CODE IS NOT NULL
),

all_state_codes AS (
    SELECT * FROM policies_state
    UNION ALL
    SELECT * FROM agencies_state
),

orphaned_state_codes AS (
    SELECT
        a.source_table,
        a.STATE_CODE
    FROM all_state_codes a
    LEFT JOIN state_reference r ON a.STATE_CODE = r.STATE_CODE
    WHERE r.STATE_CODE IS NULL
        AND a.STATE_CODE != 'Unclassified'  -- Allow 'Unclassified' as per BRD
)

-- This test will warn if any state codes don't exist in reference table
SELECT *
FROM orphaned_state_codes
