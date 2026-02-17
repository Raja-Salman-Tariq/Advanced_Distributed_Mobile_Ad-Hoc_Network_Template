

WITH source AS (
    SELECT * FROM SENTINEL_INSURANCE.BRONZE.POLICY
),

standardized AS (
    SELECT
        -- Primary Key
        POLICY_ID,

        -- Business Identifiers
        POLICY_NUMBER,
        POLICY_VERSION,

        -- Dates
        TRY_TO_DATE(EFFECTIVE_DATE) AS EFFECTIVE_DATE,
        TRY_TO_DATE(EXPIRATION_DATE) AS EXPIRATION_DATE,
        TRY_TO_DATE(CANCELLATION_DATE) AS CANCELLATION_DATE,

        -- Status & Classification
        STATUS,
        COALESCE(LOB_CODE, 'Unclassified') AS LOB_CODE,
        COALESCE(STATE_CODE, 'Unclassified') AS STATE_CODE,
        TERRITORY_CODE,

        -- Financial
        ANNUAL_PREMIUM,
        WRITTEN_PREMIUM,
        BUNDLE_DISCOUNT_PCT,

        -- Relationships
        AGENT_ID,
        PARTY_ID,

        -- Risk Attributes
        RISK_SCORE,
        IS_BUNDLE,

        -- Additional Attributes
        UNDERWRITER,
        BILLING_TYPE,
        PAYMENT_PLAN,
        CANCELLATION_REASON,

        -- Audit Fields
        CREATED_DATE,
        UPDATED_DATE

    FROM source
)

SELECT * FROM standardized