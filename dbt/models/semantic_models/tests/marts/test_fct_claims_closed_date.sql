{{
    config(
        severity='warn'
    )
}}

{#
    Business Logic Test: Closed Date should be >= Reported Date
    Claims cannot be closed before they are reported.
    Uses sampling for efficiency.
#}

WITH sampled_claims AS (
    SELECT
        CLAIM_ID,
        CLAIM_NUMBER,
        REPORTED_DATE,
        CLOSED_DATE
    FROM {{ ref('fct_claims') }}
    WHERE CLOSED_DATE IS NOT NULL
        AND REPORTED_DATE IS NOT NULL
    LIMIT 1000000
)

SELECT
    CLAIM_ID,
    CLAIM_NUMBER,
    REPORTED_DATE,
    CLOSED_DATE,
    DATEDIFF(day, REPORTED_DATE, CLOSED_DATE) AS days_to_close
FROM sampled_claims
WHERE CLOSED_DATE < REPORTED_DATE  -- Illogical: closed before reported
