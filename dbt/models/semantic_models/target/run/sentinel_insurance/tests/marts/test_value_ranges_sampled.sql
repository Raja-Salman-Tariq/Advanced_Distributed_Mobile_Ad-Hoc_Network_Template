
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Test: Comprehensive Value Range Validations (Sampled)
-- Tests multiple value range conditions across models using efficient sampling
-- Covers TOTAL_INCURRED >= 0, TOTAL_PAID >= 0, TOTAL_RESERVE >= 0, etc.

WITH claims_sample AS (
    SELECT
        'fct_claims' AS source_table,
        CLAIM_ID AS record_id,
        'TOTAL_INCURRED' AS failed_column,
        TOTAL_INCURRED AS failed_value
    FROM EKAI.demoModel_18_marts.fct_claims
    SAMPLE BERNOULLI (50000 ROWS)
    WHERE TOTAL_INCURRED < 0

    UNION ALL

    SELECT
        'fct_claims' AS source_table,
        CLAIM_ID AS record_id,
        'TOTAL_PAID' AS failed_column,
        TOTAL_PAID AS failed_value
    FROM EKAI.demoModel_18_marts.fct_claims
    SAMPLE BERNOULLI (50000 ROWS)
    WHERE TOTAL_PAID < 0

    UNION ALL

    SELECT
        'fct_claims' AS source_table,
        CLAIM_ID AS record_id,
        'TOTAL_RESERVE' AS failed_column,
        TOTAL_RESERVE AS failed_value
    FROM EKAI.demoModel_18_marts.fct_claims
    SAMPLE BERNOULLI (50000 ROWS)
    WHERE TOTAL_RESERVE < 0
),

premiums_sample AS (
    SELECT
        'fct_policy_premiums' AS source_table,
        PREMIUM_ID AS record_id,
        'EARNED_PREMIUM' AS failed_column,
        EARNED_PREMIUM AS failed_value
    FROM EKAI.demoModel_18_marts.fct_policy_premiums
    SAMPLE BERNOULLI (50000 ROWS)
    WHERE EARNED_PREMIUM < 0

    UNION ALL

    SELECT
        'fct_policy_premiums' AS source_table,
        PREMIUM_ID AS record_id,
        'WRITTEN_PREMIUM' AS failed_column,
        WRITTEN_PREMIUM AS failed_value
    FROM EKAI.demoModel_18_marts.fct_policy_premiums
    SAMPLE BERNOULLI (50000 ROWS)
    WHERE WRITTEN_PREMIUM < 0

    UNION ALL

    SELECT
        'fct_policy_premiums' AS source_table,
        PREMIUM_ID AS record_id,
        'COMMISSION_AMOUNT' AS failed_column,
        COMMISSION_AMOUNT AS failed_value
    FROM EKAI.demoModel_18_marts.fct_policy_premiums
    SAMPLE BERNOULLI (50000 ROWS)
    WHERE COMMISSION_AMOUNT < 0

    UNION ALL

    SELECT
        'fct_policy_premiums' AS source_table,
        PREMIUM_ID AS record_id,
        'AGENT_NET_REVENUE' AS failed_column,
        AGENT_NET_REVENUE AS failed_value
    FROM EKAI.demoModel_18_marts.fct_policy_premiums
    SAMPLE BERNOULLI (50000 ROWS)
    WHERE AGENT_NET_REVENUE < 0
),

policies_sample AS (
    SELECT
        'dim_policies' AS source_table,
        POLICY_ID AS record_id,
        'ANNUAL_PREMIUM' AS failed_column,
        ANNUAL_PREMIUM AS failed_value
    FROM EKAI.demoModel_18_marts.dim_policies
    SAMPLE BERNOULLI (20000 ROWS)
    WHERE ANNUAL_PREMIUM IS NOT NULL AND ANNUAL_PREMIUM <= 0

    UNION ALL

    SELECT
        'dim_policies' AS source_table,
        POLICY_ID AS record_id,
        'RISK_SCORE' AS failed_column,
        RISK_SCORE AS failed_value
    FROM EKAI.demoModel_18_marts.dim_policies
    SAMPLE BERNOULLI (20000 ROWS)
    WHERE RISK_SCORE IS NOT NULL AND (RISK_SCORE < 1 OR RISK_SCORE > 100)
),

agents_sample AS (
    SELECT
        'dim_agents' AS source_table,
        AGENT_ID AS record_id,
        'COMMISSION_SPLIT' AS failed_column,
        COMMISSION_SPLIT AS failed_value
    FROM EKAI.demoModel_18_marts.dim_agents
    WHERE COMMISSION_SPLIT IS NOT NULL AND (COMMISSION_SPLIT < 0 OR COMMISSION_SPLIT > 1)
),

agencies_sample AS (
    SELECT
        'dim_agencies' AS source_table,
        AGENCY_ID AS record_id,
        'COMMISSION_RATE' AS failed_column,
        COMMISSION_RATE AS failed_value
    FROM EKAI.demoModel_18_marts.dim_agencies
    WHERE COMMISSION_RATE IS NOT NULL AND (COMMISSION_RATE < 0 OR COMMISSION_RATE > 1)
),

all_failures AS (
    SELECT * FROM claims_sample
    UNION ALL
    SELECT * FROM premiums_sample
    UNION ALL
    SELECT * FROM policies_sample
    UNION ALL
    SELECT * FROM agents_sample
    UNION ALL
    SELECT * FROM agencies_sample
)

-- This test will fail if any values are outside expected ranges
SELECT *
FROM all_failures
  
  
      
    ) dbt_internal_test