

WITH source AS (
    SELECT * FROM SENTINEL_INSURANCE.BRONZE.REF_CAUSE_OF_LOSS
),

standardized AS (
    SELECT
        -- Primary Key
        CAUSE_ID,

        -- Business Identifiers
        CAUSE_CODE,
        CAUSE_NAME,

        -- Classification
        CAUSE_CATEGORY,

        -- Statistical Metrics
        AVG_SEVERITY,
        FREQUENCY_WEIGHT,

        -- Audit Fields
        CREATED_DATE

    FROM source
)

SELECT * FROM standardized