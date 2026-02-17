{{
    config(
        materialized='view'
    )
}}

WITH coverage_codes AS (
    SELECT * FROM {{ ref('stg_ref_coverage_codes') }}
),

final AS (
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
        IS_REQUIRED

    FROM coverage_codes
)

SELECT * FROM final
