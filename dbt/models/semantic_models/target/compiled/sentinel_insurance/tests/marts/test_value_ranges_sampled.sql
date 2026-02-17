-- Test: Comprehensive Value Range Validations (Sampled)
-- Tests multiple value range conditions across models using efficient sampling
-- Covers TOTAL_INCURRED >= 0, TOTAL_PAID >= 0, TOTAL_RESERVE >= 0, etc.

WITH claims_sample AS (
    SELECT
        'fct_claims' AS SOURCE_TABLE,
        CLAIM_ID AS RECORD_ID,
        'TOTAL_INCURRED' AS FAILED_COLUMN,
        TOTAL_INCURRED AS FAILED_VALUE
    FROM EKAI.demoModel_18_marts.fct_claims
    WHERE TOTAL_INCURRED < 0
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= 50000

    UNION ALL

    SELECT
        'fct_claims' AS SOURCE_TABLE,
        CLAIM_ID AS RECORD_ID,
        'TOTAL_PAID' AS FAILED_COLUMN,
        TOTAL_PAID AS FAILED_VALUE
    FROM EKAI.demoModel_18_marts.fct_claims
    WHERE TOTAL_PAID < 0
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= 50000

    UNION ALL

    SELECT
        'fct_claims' AS SOURCE_TABLE,
        CLAIM_ID AS RECORD_ID,
        'TOTAL_RESERVE' AS FAILED_COLUMN,
        TOTAL_RESERVE AS FAILED_VALUE
    FROM EKAI.demoModel_18_marts.fct_claims
    WHERE TOTAL_RESERVE < 0
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= 50000
),

premiums_sample AS (
    SELECT
        'fct_policy_premiums' AS SOURCE_TABLE,
        PREMIUM_ID AS RECORD_ID,
        'EARNED_PREMIUM' AS FAILED_COLUMN,
        EARNED_PREMIUM AS FAILED_VALUE
    FROM EKAI.demoModel_18_marts.fct_policy_premiums
    WHERE EARNED_PREMIUM < 0
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= 50000

    UNION ALL

    SELECT
        'fct_policy_premiums' AS SOURCE_TABLE,
        PREMIUM_ID AS RECORD_ID,
        'WRITTEN_PREMIUM' AS FAILED_COLUMN,
        WRITTEN_PREMIUM AS FAILED_VALUE
    FROM EKAI.demoModel_18_marts.fct_policy_premiums
    WHERE WRITTEN_PREMIUM < 0
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= 50000

    UNION ALL

    SELECT
        'fct_policy_premiums' AS SOURCE_TABLE,
        PREMIUM_ID AS RECORD_ID,
        'COMMISSION_AMOUNT' AS FAILED_COLUMN,
        COMMISSION_AMOUNT AS FAILED_VALUE
    FROM EKAI.demoModel_18_marts.fct_policy_premiums
    WHERE COMMISSION_AMOUNT < 0
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= 50000

    UNION ALL

    SELECT
        'fct_policy_premiums' AS SOURCE_TABLE,
        PREMIUM_ID AS RECORD_ID,
        'AGENT_NET_REVENUE' AS FAILED_COLUMN,
        AGENT_NET_REVENUE AS FAILED_VALUE
    FROM EKAI.demoModel_18_marts.fct_policy_premiums
    WHERE AGENT_NET_REVENUE < 0
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= 50000
),

policies_sample AS (
    SELECT
        'dim_policies' AS SOURCE_TABLE,
        POLICY_ID AS RECORD_ID,
        'ANNUAL_PREMIUM' AS FAILED_COLUMN,
        ANNUAL_PREMIUM AS FAILED_VALUE
    FROM EKAI.demoModel_18_marts.dim_policies
    WHERE ANNUAL_PREMIUM IS NOT NULL AND ANNUAL_PREMIUM <= 0
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= 20000

    UNION ALL

    SELECT
        'dim_policies' AS SOURCE_TABLE,
        POLICY_ID AS RECORD_ID,
        'RISK_SCORE' AS FAILED_COLUMN,
        RISK_SCORE AS FAILED_VALUE
    FROM EKAI.demoModel_18_marts.dim_policies
    WHERE RISK_SCORE IS NOT NULL AND (RISK_SCORE < 1 OR RISK_SCORE > 100)
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= 20000
),

agents_sample AS (
    SELECT
        'dim_agents' AS SOURCE_TABLE,
        AGENT_ID AS RECORD_ID,
        'COMMISSION_SPLIT' AS FAILED_COLUMN,
        COMMISSION_SPLIT AS FAILED_VALUE
    FROM EKAI.demoModel_18_marts.dim_agents
    WHERE COMMISSION_SPLIT IS NOT NULL AND (COMMISSION_SPLIT < 0 OR COMMISSION_SPLIT > 1)
),

agencies_sample AS (
    SELECT
        'dim_agencies' AS SOURCE_TABLE,
        AGENCY_ID AS RECORD_ID,
        'COMMISSION_RATE' AS FAILED_COLUMN,
        COMMISSION_RATE AS FAILED_VALUE
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