
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Test: Loss Ratio Reasonableness Check (Cross-Model Consistency)
-- Validates that Loss Ratio (Total Incurred / Earned Premium) is between 0 and 2 (200%)
-- Uses stratified sampling by LOB_CODE for efficiency and representation

WITH sampled_claims AS (
    -- Stratified sample: 10k rows per LOB (if available)
    SELECT
        POLICY_ID,
        LOB_CODE,
        TOTAL_INCURRED
    FROM EKAI.demoModel_18_marts.fct_claims
    WHERE TOTAL_INCURRED IS NOT NULL
    QUALIFY ROW_NUMBER() OVER (PARTITION BY LOB_CODE ORDER BY RANDOM()) <= 10000
),

sampled_premiums AS (
    -- Stratified sample: Match policies from claims
    SELECT
        p.POLICY_ID,
        p.LOB_CODE,
        SUM(pp.EARNED_PREMIUM) AS TOTAL_EARNED_PREMIUM
    FROM EKAI.demoModel_18_marts.dim_policies p
    INNER JOIN EKAI.demoModel_18_marts.fct_policy_premiums pp ON p.POLICY_ID = pp.POLICY_ID
    WHERE pp.EARNED_PREMIUM IS NOT NULL
    GROUP BY p.POLICY_ID, p.LOB_CODE
),

lob_aggregates AS (
    SELECT
        COALESCE(c.LOB_CODE, p.LOB_CODE) AS LOB_CODE,
        SUM(c.TOTAL_INCURRED) AS TOTAL_INCURRED,
        SUM(p.TOTAL_EARNED_PREMIUM) AS TOTAL_EARNED_PREMIUM
    FROM sampled_claims c
    FULL OUTER JOIN sampled_premiums p ON c.POLICY_ID = p.POLICY_ID
    GROUP BY COALESCE(c.LOB_CODE, p.LOB_CODE)
),

loss_ratio_check AS (
    SELECT
        LOB_CODE,
        TOTAL_INCURRED,
        TOTAL_EARNED_PREMIUM,
        CASE
            WHEN TOTAL_EARNED_PREMIUM = 0 OR TOTAL_EARNED_PREMIUM IS NULL THEN NULL
            ELSE TOTAL_INCURRED / TOTAL_EARNED_PREMIUM
        END AS LOSS_RATIO
    FROM lob_aggregates
),

failed_checks AS (
    SELECT
        LOB_CODE,
        TOTAL_INCURRED,
        TOTAL_EARNED_PREMIUM,
        LOSS_RATIO
    FROM loss_ratio_check
    WHERE LOSS_RATIO IS NOT NULL
        AND (LOSS_RATIO < 0 OR LOSS_RATIO > 2)
)

-- This test will warn if loss ratio is outside reasonable bounds
SELECT *
FROM failed_checks
  
  
      
    ) dbt_internal_test