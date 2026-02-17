{{
    config(
        materialized='view'
    )
}}

WITH source AS (
    SELECT * FROM {{ source('SENTINEL_INSURANCE', 'REF_COVERAGE_CODE') }}
),

standardized AS (
    SELECT
        -- Primary Key
        COVERAGE_ID,

        -- Business Identifiers
        COVERAGE_CODE,
        COVERAGE_NAME,

        -- Classification
        LOB_CODE,

        -- Default Terms
        DEFAULT_LIMIT,
        DEFAULT_DEDUCTIBLE,

        -- Requirements
        IS_REQUIRED,

        -- Audit Fields
        CREATED_DATE

    FROM source
)

SELECT * FROM standardized
