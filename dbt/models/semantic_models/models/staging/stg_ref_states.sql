{{
    config(
        materialized='view'
    )
}}

WITH source AS (
    SELECT * FROM {{ source('SENTINEL_INSURANCE', 'REF_STATE') }}
),

standardized AS (
    SELECT
        -- Primary Key
        STATE_ID,

        -- Business Identifiers
        STATE_CODE,
        STATE_NAME,

        -- Geographic Classification
        REGION,
        TERRITORY_CODE,

        -- Regulatory Attributes
        NO_FAULT_AUTO,
        WC_MONOPOLISTIC,

        -- Audit Fields
        CREATED_DATE

    FROM source
)

SELECT * FROM standardized
