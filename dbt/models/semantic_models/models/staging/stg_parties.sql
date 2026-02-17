{{
    config(
        materialized='view'
    )
}}

WITH source AS (
    SELECT * FROM {{ source('SENTINEL_INSURANCE', 'PARTY') }}
),

standardized AS (
    SELECT
        -- Primary Key
        PARTY_ID,

        -- Party Classification
        PARTY_TYPE,
        PARTY_NAME,

        -- Individual Information
        FIRST_NAME,
        LAST_NAME,
        TRY_TO_DATE(DATE_OF_BIRTH) AS DATE_OF_BIRTH,
        GENDER,
        SSN_ENCRYPTED,
        CREDIT_SCORE,

        -- Organization Information
        EIN_ENCRYPTED,

        -- Relationship Information
        TRY_TO_DATE(CUSTOMER_SINCE) AS CUSTOMER_SINCE,
        IS_ACTIVE,

        -- Location Information
        PRIMARY_STATE,

        -- Contact Information
        PHONE,
        EMAIL,

        -- Audit Fields
        CREATED_DATE,
        UPDATED_DATE

    FROM source
)

SELECT * FROM standardized
