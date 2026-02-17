{{
    config(
        severity='error'
    )
}}

{#
    Business Logic Test: Current Exposure - One row per POLICY_NUMBER
    Critical test ensuring only latest version per policy exists.
    This is essential for accurate Current Exposure KPI calculations.
#}

WITH policy_counts AS (
    SELECT
        POLICY_NUMBER,
        COUNT(*) AS version_count,
        MAX(POLICY_VERSION) AS max_version
    FROM {{ ref('dim_policies') }}
    GROUP BY POLICY_NUMBER
    HAVING COUNT(*) > 1  -- Find policy numbers with multiple versions
)

SELECT
    POLICY_NUMBER,
    version_count,
    max_version
FROM policy_counts
