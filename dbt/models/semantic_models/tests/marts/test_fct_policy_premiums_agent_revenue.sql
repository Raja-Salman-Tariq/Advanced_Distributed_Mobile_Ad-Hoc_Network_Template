{{
    config(
        severity='warn'
    )
}}

{#
    Business Logic Test: Agent Net Revenue = Commission Amount × Commission Split
    Validates the agent revenue calculation formula from BRD.
    Uses sampling with join to dim_agents for commission split rate.
#}

WITH sampled_premiums AS (
    SELECT
        p.PREMIUM_ID,
        p.POLICY_ID,
        p.COMMISSION_AMOUNT,
        p.AGENT_NET_REVENUE,
        a.COMMISSION_SPLIT
    FROM {{ ref('fct_policy_premiums') }} p
    LEFT JOIN {{ ref('dim_policies') }} pol ON p.POLICY_ID = pol.POLICY_ID
    LEFT JOIN {{ ref('dim_agents') }} a ON pol.AGENT_ID = a.AGENT_ID
    WHERE p.AGENT_NET_REVENUE IS NOT NULL
        AND p.COMMISSION_AMOUNT IS NOT NULL
    LIMIT 1000000
),

validation AS (
    SELECT
        PREMIUM_ID,
        COMMISSION_AMOUNT,
        COMMISSION_SPLIT,
        AGENT_NET_REVENUE,
        (COMMISSION_AMOUNT * COALESCE(COMMISSION_SPLIT, 0)) AS expected_revenue,
        ABS(AGENT_NET_REVENUE - (COMMISSION_AMOUNT * COALESCE(COMMISSION_SPLIT, 0))) AS revenue_diff
    FROM sampled_premiums
)

SELECT
    PREMIUM_ID,
    COMMISSION_AMOUNT,
    COMMISSION_SPLIT,
    AGENT_NET_REVENUE,
    expected_revenue,
    revenue_diff
FROM validation
WHERE revenue_diff >= 0.01  -- Allow for rounding tolerance
