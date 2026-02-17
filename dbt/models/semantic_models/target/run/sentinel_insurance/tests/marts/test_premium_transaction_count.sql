
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Test: Premium Transaction Count Reasonableness (Sampled)
-- Validates that active policies have at least one premium transaction
-- Uses sampling to limit performance impact

WITH sampled_active_policies AS (
    SELECT
        POLICY_ID,
        POLICY_NUMBER,
        STATUS
    FROM EKAI.demoModel_18_marts.dim_policies
    WHERE STATUS = 'Active'
    -- Sample 5,000 active policies using QUALIFY
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= 5000
),

premium_transaction_count AS (
    SELECT
        p.POLICY_ID,
        p.POLICY_NUMBER,
        p.STATUS,
        COUNT(pp.PREMIUM_ID) AS PREMIUM_TRANSACTION_COUNT
    FROM sampled_active_policies p
    LEFT JOIN EKAI.demoModel_18_marts.fct_policy_premiums pp ON p.POLICY_ID = pp.POLICY_ID
    GROUP BY p.POLICY_ID, p.POLICY_NUMBER, p.STATUS
),

policies_without_premiums AS (
    SELECT
        POLICY_ID,
        POLICY_NUMBER,
        STATUS,
        PREMIUM_TRANSACTION_COUNT
    FROM premium_transaction_count
    WHERE PREMIUM_TRANSACTION_COUNT = 0
)

-- This test will warn if active policies have no premium transactions
SELECT *
FROM policies_without_premiums
  
  
      
    ) dbt_internal_test