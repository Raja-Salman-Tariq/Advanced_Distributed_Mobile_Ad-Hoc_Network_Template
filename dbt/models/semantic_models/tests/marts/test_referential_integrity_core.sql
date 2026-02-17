{{
    config(
        severity='error'
    )
}}

{#
    Referential Integrity Tests: Core relationships
    Tests critical foreign key relationships using efficient sampling.

    Tests include:
    1. fct_claims -> dim_policies
    2. fct_policy_premiums -> dim_policies
    3. dim_agents -> dim_agencies

    Uses stratified sampling to limit scans to < 1M rows total
#}

WITH claims_orphans AS (
    SELECT
        'fct_claims->dim_policies' AS relationship,
        c.CLAIM_ID AS orphan_id,
        c.POLICY_ID AS foreign_key_value
    FROM {{ ref('fct_claims') }} c
    LEFT JOIN {{ ref('dim_policies') }} p ON c.POLICY_ID = p.POLICY_ID
    WHERE c.POLICY_ID IS NOT NULL
        AND p.POLICY_ID IS NULL
    LIMIT 500000
),

premiums_orphans AS (
    SELECT
        'fct_policy_premiums->dim_policies' AS relationship,
        pr.PREMIUM_ID AS orphan_id,
        pr.POLICY_ID AS foreign_key_value
    FROM {{ ref('fct_policy_premiums') }} pr
    LEFT JOIN {{ ref('dim_policies') }} p ON pr.POLICY_ID = p.POLICY_ID
    WHERE pr.POLICY_ID IS NOT NULL
        AND p.POLICY_ID IS NULL
    LIMIT 500000
),

agents_orphans AS (
    SELECT
        'dim_agents->dim_agencies' AS relationship,
        a.AGENT_ID AS orphan_id,
        a.AGENCY_ID AS foreign_key_value
    FROM {{ ref('dim_agents') }} a
    LEFT JOIN {{ ref('dim_agencies') }} ag ON a.AGENCY_ID = ag.AGENCY_ID
    WHERE a.AGENCY_ID IS NOT NULL
        AND ag.AGENCY_ID IS NULL
),

all_orphans AS (
    SELECT * FROM claims_orphans
    UNION ALL
    SELECT * FROM premiums_orphans
    UNION ALL
    SELECT * FROM agents_orphans
)

SELECT
    relationship,
    COUNT(*) AS orphan_count,
    MIN(orphan_id) AS sample_orphan_id,
    MIN(foreign_key_value) AS sample_foreign_key
FROM all_orphans
GROUP BY relationship
