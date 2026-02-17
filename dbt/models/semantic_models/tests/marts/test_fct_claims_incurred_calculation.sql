{{
    config(
        severity='warn'
    )
}}

{#
    Business Logic Test: Total Incurred = Total Paid + Total Reserve
    Uses sampling to efficiently validate the fundamental claim accounting equation.
    Allows for 0.01 rounding tolerance.
#}

WITH sampled_claims AS (
    SELECT
        CLAIM_ID,
        TOTAL_INCURRED,
        TOTAL_PAID,
        TOTAL_RESERVE,
        ABS(TOTAL_INCURRED - (COALESCE(TOTAL_PAID, 0) + COALESCE(TOTAL_RESERVE, 0))) AS calculation_diff
    FROM {{ ref('fct_claims') }}
    WHERE TOTAL_INCURRED IS NOT NULL
    LIMIT 1000000
)

SELECT
    CLAIM_ID,
    TOTAL_INCURRED,
    TOTAL_PAID,
    TOTAL_RESERVE,
    calculation_diff
FROM sampled_claims
WHERE calculation_diff >= 0.01  -- Allow for rounding tolerance
