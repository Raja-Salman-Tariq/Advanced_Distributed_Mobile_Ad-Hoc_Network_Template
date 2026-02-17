-- Test: Efficient Primary Key Uniqueness Check using HyperLogLog (Probabilistic)
-- Tests multiple models for PK uniqueness using approximate distinct counts
-- This is more efficient than full scans for large datasets

WITH fct_claims_check AS (
    SELECT
        'fct_claims' AS model_name,
        'CLAIM_ID' AS pk_column,
        COUNT(*) AS total_rows,
        HLL(CLAIM_ID) AS approx_distinct_count
    FROM EKAI.demoModel_18_marts.fct_claims
    HAVING COUNT(*) != HLL(CLAIM_ID)
),

fct_claim_payments_check AS (
    SELECT
        'fct_claim_payments' AS model_name,
        'PAYMENT_ID' AS pk_column,
        COUNT(*) AS total_rows,
        HLL(PAYMENT_ID) AS approx_distinct_count
    FROM EKAI.demoModel_18_marts.fct_claim_payments
    HAVING COUNT(*) != HLL(PAYMENT_ID)
),

fct_policy_premiums_check AS (
    SELECT
        'fct_policy_premiums' AS model_name,
        'PREMIUM_ID' AS pk_column,
        COUNT(*) AS total_rows,
        HLL(PREMIUM_ID) AS approx_distinct_count
    FROM EKAI.demoModel_18_marts.fct_policy_premiums
    HAVING COUNT(*) != HLL(PREMIUM_ID)
),

dim_policies_check AS (
    SELECT
        'dim_policies' AS model_name,
        'POLICY_ID' AS pk_column,
        COUNT(*) AS total_rows,
        HLL(POLICY_ID) AS approx_distinct_count
    FROM EKAI.demoModel_18_marts.dim_policies
    HAVING COUNT(*) != HLL(POLICY_ID)
),

dim_agents_check AS (
    SELECT
        'dim_agents' AS model_name,
        'AGENT_ID' AS pk_column,
        COUNT(*) AS total_rows,
        HLL(AGENT_ID) AS approx_distinct_count
    FROM EKAI.demoModel_18_marts.dim_agents
    HAVING COUNT(*) != HLL(AGENT_ID)
),

dim_agencies_check AS (
    SELECT
        'dim_agencies' AS model_name,
        'AGENCY_ID' AS pk_column,
        COUNT(*) AS total_rows,
        HLL(AGENCY_ID) AS approx_distinct_count
    FROM EKAI.demoModel_18_marts.dim_agencies
    HAVING COUNT(*) != HLL(AGENCY_ID)
),

all_failures AS (
    SELECT * FROM fct_claims_check
    UNION ALL
    SELECT * FROM fct_claim_payments_check
    UNION ALL
    SELECT * FROM fct_policy_premiums_check
    UNION ALL
    SELECT * FROM dim_policies_check
    UNION ALL
    SELECT * FROM dim_agents_check
    UNION ALL
    SELECT * FROM dim_agencies_check
)

-- This test will fail if any model has duplicate primary keys
SELECT *
FROM all_failures