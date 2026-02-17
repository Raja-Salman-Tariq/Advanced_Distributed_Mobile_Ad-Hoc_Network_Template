
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Test: Critical NOT NULL Validations (Efficient Sampling)
-- Uses HLL (HyperLogLog) to efficiently count NULL values in critical fields
-- This is more efficient than scanning all rows for large datasets

WITH fct_claims_nulls AS (
    SELECT
        'fct_claims' AS source_table,
        'CLAIM_ID' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN CLAIM_ID IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.fct_claims
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN CLAIM_ID IS NULL THEN 1 END) > 0

    UNION ALL

    SELECT
        'fct_claims' AS source_table,
        'POLICY_ID' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN POLICY_ID IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.fct_claims
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN POLICY_ID IS NULL THEN 1 END) > 0

    UNION ALL

    SELECT
        'fct_claims' AS source_table,
        'LOB_CODE' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN LOB_CODE IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.fct_claims
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN LOB_CODE IS NULL THEN 1 END) > 0

    UNION ALL

    SELECT
        'fct_claims' AS source_table,
        'TOTAL_INCURRED' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN TOTAL_INCURRED IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.fct_claims
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN TOTAL_INCURRED IS NULL THEN 1 END) > 0
),

fct_policy_premiums_nulls AS (
    SELECT
        'fct_policy_premiums' AS source_table,
        'PREMIUM_ID' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN PREMIUM_ID IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.fct_policy_premiums
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN PREMIUM_ID IS NULL THEN 1 END) > 0

    UNION ALL

    SELECT
        'fct_policy_premiums' AS source_table,
        'POLICY_ID' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN POLICY_ID IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.fct_policy_premiums
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN POLICY_ID IS NULL THEN 1 END) > 0

    UNION ALL

    SELECT
        'fct_policy_premiums' AS source_table,
        'EARNED_PREMIUM' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN EARNED_PREMIUM IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.fct_policy_premiums
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN EARNED_PREMIUM IS NULL THEN 1 END) > 0
),

dim_policies_nulls AS (
    SELECT
        'dim_policies' AS source_table,
        'POLICY_ID' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN POLICY_ID IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.dim_policies
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN POLICY_ID IS NULL THEN 1 END) > 0

    UNION ALL

    SELECT
        'dim_policies' AS source_table,
        'POLICY_NUMBER' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN POLICY_NUMBER IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.dim_policies
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN POLICY_NUMBER IS NULL THEN 1 END) > 0

    UNION ALL

    SELECT
        'dim_policies' AS source_table,
        'POLICY_VERSION' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN POLICY_VERSION IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.dim_policies
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN POLICY_VERSION IS NULL THEN 1 END) > 0

    UNION ALL

    SELECT
        'dim_policies' AS source_table,
        'LOB_CODE' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN LOB_CODE IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.dim_policies
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN LOB_CODE IS NULL THEN 1 END) > 0

    UNION ALL

    SELECT
        'dim_policies' AS source_table,
        'STATE_CODE' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN STATE_CODE IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.dim_policies
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN STATE_CODE IS NULL THEN 1 END) > 0
),

dim_agents_nulls AS (
    SELECT
        'dim_agents' AS source_table,
        'AGENT_ID' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN AGENT_ID IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.dim_agents
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN AGENT_ID IS NULL THEN 1 END) > 0

    UNION ALL

    SELECT
        'dim_agents' AS source_table,
        'AGENCY_ID' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN AGENCY_ID IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.dim_agents
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN AGENCY_ID IS NULL THEN 1 END) > 0

    UNION ALL

    SELECT
        'dim_agents' AS source_table,
        'COMMISSION_SPLIT' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN COMMISSION_SPLIT IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.dim_agents
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN COMMISSION_SPLIT IS NULL THEN 1 END) > 0
),

dim_agencies_nulls AS (
    SELECT
        'dim_agencies' AS source_table,
        'AGENCY_ID' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN AGENCY_ID IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.dim_agencies
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN AGENCY_ID IS NULL THEN 1 END) > 0

    UNION ALL

    SELECT
        'dim_agencies' AS source_table,
        'COMMISSION_RATE' AS column_name,
        APPROX_COUNT_DISTINCT(CASE WHEN COMMISSION_RATE IS NULL THEN 1 END) AS approx_null_count
    FROM EKAI.demoModel_18_marts.dim_agencies
    HAVING APPROX_COUNT_DISTINCT(CASE WHEN COMMISSION_RATE IS NULL THEN 1 END) > 0
),

all_null_violations AS (
    SELECT * FROM fct_claims_nulls
    UNION ALL
    SELECT * FROM fct_policy_premiums_nulls
    UNION ALL
    SELECT * FROM dim_policies_nulls
    UNION ALL
    SELECT * FROM dim_agents_nulls
    UNION ALL
    SELECT * FROM dim_agencies_nulls
)

-- This test will fail if any critical fields have NULL values
SELECT *
FROM all_null_violations
  
  
      
    ) dbt_internal_test