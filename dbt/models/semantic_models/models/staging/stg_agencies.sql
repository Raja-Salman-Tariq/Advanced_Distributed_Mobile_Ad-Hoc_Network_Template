{{
    config(
        materialized='view'
    )
}}

WITH source AS (
    SELECT * FROM {{ source('SENTINEL_INSURANCE', 'AGENCY') }}
),

standardized AS (
    SELECT
        -- Primary Key
        AGENCY_ID,

        -- Business Identifiers
        AGENCY_CODE,
        AGENCY_NAME,

        -- Agency Details
        AGENCY_TYPE,
        COMMISSION_RATE,

        -- Status & Licensing
        IS_ACTIVE,
        LICENSE_NUMBER,
        TRY_TO_DATE(APPOINTMENT_DATE) AS APPOINTMENT_DATE,

        -- Location Information
        STATE_CODE,
        CITY,
        ADDRESS,
        ZIP_CODE,

        -- Contact Information
        PHONE,
        EMAIL,

        -- Audit Fields
        CREATED_DATE

    FROM source
)

SELECT * FROM standardized
