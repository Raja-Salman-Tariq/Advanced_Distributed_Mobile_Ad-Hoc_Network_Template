
  create or replace   view EKAI.demoModel_18_marts.dim_policies
  
   as (
    

WITH policies AS (
    SELECT * FROM EKAI.demoModel_18_staging.stg_policies
),

parties AS (
    SELECT * FROM EKAI.demoModel_18_staging.stg_parties
),

-- Current Exposure Logic: Get latest version per policy number
latest_versions AS (
    SELECT
        POLICY_NUMBER,
        MAX(POLICY_VERSION) AS MAX_VERSION
    FROM policies
    GROUP BY POLICY_NUMBER
),

current_exposure AS (
    SELECT
        p.POLICY_ID,
        p.POLICY_NUMBER,
        p.POLICY_VERSION,
        p.EFFECTIVE_DATE,
        p.EXPIRATION_DATE,
        p.STATUS,
        p.LOB_CODE,
        p.STATE_CODE,
        p.ANNUAL_PREMIUM,
        p.AGENT_ID,
        p.PARTY_ID,
        p.IS_BUNDLE,
        p.RISK_SCORE,

        -- Policyholder name from Party table
        pt.PARTY_NAME AS POLICYHOLDER_NAME

    FROM policies p
    INNER JOIN latest_versions lv
        ON p.POLICY_NUMBER = lv.POLICY_NUMBER
        AND p.POLICY_VERSION = lv.MAX_VERSION
    LEFT JOIN parties pt
        ON p.PARTY_ID = pt.PARTY_ID
),

final AS (
    SELECT
        -- Primary Key
        POLICY_ID,

        -- Business Identifiers
        POLICY_NUMBER,
        POLICY_VERSION,

        -- Dates
        EFFECTIVE_DATE,
        EXPIRATION_DATE,

        -- Status & Classification
        STATUS,
        LOB_CODE,
        STATE_CODE,

        -- Financial
        ANNUAL_PREMIUM,

        -- Relationships
        AGENT_ID,
        PARTY_ID,
        POLICYHOLDER_NAME,

        -- Risk Attributes
        IS_BUNDLE,
        RISK_SCORE

    FROM current_exposure
)

SELECT * FROM final
  );

