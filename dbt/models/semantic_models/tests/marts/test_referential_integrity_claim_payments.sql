{{
    config(
        severity='warn'
    )
}}

{#
    Referential Integrity Test: fct_claim_payments -> fct_claims
    Warns if payment records exist without corresponding claim record.
    Uses sampling for efficiency.
#}

WITH payment_orphans AS (
    SELECT
        cp.PAYMENT_ID,
        cp.CLAIM_ID,
        cp.PAYMENT_AMOUNT
    FROM {{ ref('fct_claim_payments') }} cp
    LEFT JOIN {{ ref('fct_claims') }} c ON cp.CLAIM_ID = c.CLAIM_ID
    WHERE cp.CLAIM_ID IS NOT NULL
        AND c.CLAIM_ID IS NULL
    LIMIT 1000000
)

SELECT
    COUNT(*) AS orphaned_payments_count,
    SUM(PAYMENT_AMOUNT) AS total_orphaned_amount,
    MIN(PAYMENT_ID) AS sample_payment_id,
    MIN(CLAIM_ID) AS sample_claim_id
FROM payment_orphans
HAVING COUNT(*) > 0
