{{
    config(
        materialized='view'
    )
}}

WITH line_of_business AS (
    SELECT * FROM {{ ref('stg_ref_line_of_business') }}
),

final AS (
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

        -- Status
        IS_ACTIVE

    FROM line_of_business
)

SELECT * FROM final
