{{
    config(
        materialized='view'
    )
}}

WITH source AS (
    SELECT * FROM {{ source('SENTINEL_INSURANCE', 'CLAIM_PAYMENT') }}
),

standardized AS (
    SELECT
        -- Primary Key
        PAYMENT_ID,

        -- Foreign Keys
        CLAIM_ID,

        -- Transaction Details
        TRY_TO_DATE(PAYMENT_DATE) AS PAYMENT_DATE,
        PAYMENT_AMOUNT,
        PAYMENT_TYPE,
        PAYMENT_METHOD,
        CHECK_NUMBER,

        -- Payee Information
        PAYEE_NAME,
        PAYEE_TYPE,

        -- Audit Fields
        CREATED_DATE

    FROM source
)

SELECT * FROM standardized
