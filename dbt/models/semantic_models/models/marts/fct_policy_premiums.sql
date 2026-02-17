{{
    config(
        materialized='view'
    )
}}

WITH policy_premiums AS (
    SELECT * FROM {{ ref('stg_policy_premiums') }}
),

policies AS (
    SELECT * FROM {{ ref('stg_policies') }}
),

agents AS (
    SELECT * FROM {{ ref('stg_agents') }}
),

enriched AS (
    SELECT
        pp.PREMIUM_ID,
        pp.POLICY_ID,
        pp.TRANSACTION_DATE,
        pp.ACCOUNTING_DATE,
        pp.TRANSACTION_TYPE,
        pp.WRITTEN_PREMIUM,
        pp.EARNED_PREMIUM,
        pp.COMMISSION_AMOUNT,
        pp.TAX_AMOUNT,
        pp.FEE_AMOUNT,

        -- Get agent commission split for Agent Net Revenue calculation
        a.COMMISSION_SPLIT

    FROM policy_premiums pp
    LEFT JOIN policies p ON pp.POLICY_ID = p.POLICY_ID
    LEFT JOIN agents a ON p.AGENT_ID = a.AGENT_ID
),

final AS (
    SELECT
        -- Primary Key
        PREMIUM_ID,

        -- Foreign Keys
        POLICY_ID,

        -- Transaction Details
        TRANSACTION_DATE,
        ACCOUNTING_DATE,
        TRANSACTION_TYPE,

        -- Financial Amounts
        WRITTEN_PREMIUM,
        EARNED_PREMIUM,
        COMMISSION_AMOUNT,
        TAX_AMOUNT,
        FEE_AMOUNT,

        -- Calculated Field: Agent Net Revenue
        -- Agent Net Revenue = Commission Amount × Agent Commission Split
        COMMISSION_AMOUNT * COALESCE(COMMISSION_SPLIT, 0) AS AGENT_NET_REVENUE

    FROM enriched
)

SELECT * FROM final
