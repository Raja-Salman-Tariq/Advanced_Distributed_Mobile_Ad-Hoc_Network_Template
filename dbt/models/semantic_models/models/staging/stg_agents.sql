{{
    config(
        materialized='view'
    )
}}

WITH source AS (
    SELECT * FROM {{ source('SENTINEL_INSURANCE', 'AGENT') }}
),

standardized AS (
    SELECT
        -- Primary Key
        AGENT_ID,

        -- Business Identifiers
        AGENT_CODE,

        -- Personal Information
        FIRST_NAME,
        LAST_NAME,
        CONCAT(FIRST_NAME, ' ', LAST_NAME) AS FULL_NAME,

        -- Foreign Keys
        AGENCY_ID,

        -- Commission Information
        COMMISSION_SPLIT,

        -- Status & Licensing
        IS_ACTIVE,
        TRY_TO_DATE(HIRE_DATE) AS HIRE_DATE,
        TRY_TO_DATE(TERMINATION_DATE) AS TERMINATION_DATE,
        LICENSE_NUMBER,
        LICENSE_STATE,
        TRY_TO_DATE(LICENSE_EXPIRATION) AS LICENSE_EXPIRATION,

        -- Contact Information
        PHONE,
        EMAIL,

        -- Audit Fields
        CREATED_DATE

    FROM source
)

SELECT * FROM standardized
