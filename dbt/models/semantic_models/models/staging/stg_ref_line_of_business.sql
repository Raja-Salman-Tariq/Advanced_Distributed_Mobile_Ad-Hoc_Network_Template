{{
    config(
        materialized='view'
    )
}}

WITH source AS (
    SELECT * FROM {{ source('SENTINEL_INSURANCE', 'REF_LINE_OF_BUSINESS') }}
),

standardized AS (
    SELECT
        -- Primary Key
        LOB_ID,

        -- Business Identifiers
        LOB_CODE,
        LOB_NAME,

        -- Classification
        SEGMENT,

        -- Benchmark Metrics
        AVG_PREMIUM,
        CLAIM_FREQUENCY,
        POLICY_WEIGHT,

        -- Status
        ACTIVE_FLAG AS IS_ACTIVE,

        -- Audit Fields
        CREATED_DATE

    FROM source
)

SELECT * FROM standardized
