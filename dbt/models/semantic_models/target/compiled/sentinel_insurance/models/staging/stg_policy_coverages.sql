

WITH source AS (
    SELECT * FROM SENTINEL_INSURANCE.BRONZE.POLICY_COVERAGE
),

standardized AS (
    SELECT
        -- Primary Key
        COVERAGE_ID,

        -- Foreign Keys
        POLICY_ID,
        COVERAGE_CODE,

        -- Coverage Details
        TRY_TO_DATE(EFFECTIVE_DATE) AS EFFECTIVE_DATE,
        TRY_TO_DATE(EXPIRATION_DATE) AS EXPIRATION_DATE,
        LIMIT_AMOUNT,
        LIMIT_TYPE,
        DEDUCTIBLE_AMOUNT,
        PREMIUM_AMOUNT,

        -- Flags
        IS_MANDATORY,

        -- Audit Fields
        CREATED_DATE

    FROM source
)

SELECT * FROM standardized