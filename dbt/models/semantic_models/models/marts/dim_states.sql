{{
    config(
        materialized='view'
    )
}}

WITH states AS (
    SELECT * FROM {{ ref('stg_ref_states') }}
),

final AS (
    SELECT
        -- Primary Key
        STATE_ID,

        -- Business Identifiers
        STATE_CODE,
        STATE_NAME,

        -- Geographic Classification
        REGION,

        -- Regulatory Attributes
        NO_FAULT_AUTO

    FROM states
)

SELECT * FROM final
