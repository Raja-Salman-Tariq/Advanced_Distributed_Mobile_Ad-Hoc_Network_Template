{{
    config(
        materialized='view'
    )
}}

WITH agencies AS (
    SELECT * FROM {{ ref('stg_agencies') }}
),

final AS (
    SELECT
        -- Primary Key
        AGENCY_ID,

        -- Business Identifiers
        AGENCY_CODE,
        AGENCY_NAME,

        -- Agency Details
        AGENCY_TYPE,
        COMMISSION_RATE,

        -- Status
        IS_ACTIVE,

        -- Location
        STATE_CODE,
        CITY

    FROM agencies
)

SELECT * FROM final
