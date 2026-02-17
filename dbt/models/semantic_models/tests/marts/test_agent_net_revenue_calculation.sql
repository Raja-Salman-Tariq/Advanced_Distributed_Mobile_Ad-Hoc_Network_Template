-- Test: Agent Net Revenue Calculation Validation (Sampled)
-- Validates AGENT_NET_REVENUE = COMMISSION_AMOUNT × COMMISSION_SPLIT
-- Uses sampling to limit scan to ~10,000 rows for efficiency

WITH sampled_premiums AS (
    SELECT
        pp.PREMIUM_ID,
        pp.COMMISSION_AMOUNT,
        pp.AGENT_NET_REVENUE,
        p.AGENT_ID,
        a.COMMISSION_SPLIT
    FROM {{ ref('fct_policy_premiums') }} pp
    LEFT JOIN {{ ref('dim_policies') }} p ON pp.POLICY_ID = p.POLICY_ID
    LEFT JOIN {{ ref('dim_agents') }} a ON p.AGENT_ID = a.AGENT_ID
    WHERE pp.COMMISSION_AMOUNT IS NOT NULL
        AND pp.AGENT_NET_REVENUE IS NOT NULL
    -- Efficient sampling using QUALIFY clause
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= 10000
),

failed_calculations AS (
    SELECT
        PREMIUM_ID,
        COMMISSION_AMOUNT,
        COMMISSION_SPLIT,
        AGENT_NET_REVENUE,
        COMMISSION_AMOUNT * COALESCE(COMMISSION_SPLIT, 0) AS expected_agent_net_revenue,
        ABS(AGENT_NET_REVENUE - (COMMISSION_AMOUNT * COALESCE(COMMISSION_SPLIT, 0))) AS difference
    FROM sampled_premiums
    WHERE ABS(AGENT_NET_REVENUE - (COMMISSION_AMOUNT * COALESCE(COMMISSION_SPLIT, 0))) >= 0.01
)

-- This test will fail if any sampled records have incorrect calculations
SELECT *
FROM failed_calculations
