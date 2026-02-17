{{
    config(
        severity='warn'
    )
}}

{#
    Business Logic Test: Loss Date should be <= Reported Date
    Validates logical date sequencing - claims should be reported after loss occurs.
    Uses sampling for efficiency.
#}

WITH sampled_claims AS (
    SELECT
        CLAIM_ID,
        CLAIM_NUMBER,
        LOSS_DATE,
        REPORTED_DATE
    FROM {{ ref('fct_claims') }}
    WHERE LOSS_DATE IS NOT NULL
        AND REPORTED_DATE IS NOT NULL
    LIMIT 1000000
)

SELECT
    CLAIM_ID,
    CLAIM_NUMBER,
    LOSS_DATE,
    REPORTED_DATE,
    DATEDIFF(day, LOSS_DATE, REPORTED_DATE) AS days_to_report
FROM sampled_claims
WHERE LOSS_DATE > REPORTED_DATE  -- Illogical: loss after report
