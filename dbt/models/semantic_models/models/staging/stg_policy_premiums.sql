{{
    config(
        materialized='view'
    )
}}

WITH source AS (
    SELECT * FROM {{ source('SENTINEL_INSURANCE', 'POLICY_PREMIUM') }}
),

standardized AS (
    SELECT
        -- Primary Key
        PREMIUM_ID,

        -- Foreign Keys
        POLICY_ID,

        -- Transaction Details
        TRY_TO_DATE(TRANSACTION_DATE) AS TRANSACTION_DATE,
        TRY_TO_DATE(ACCOUNTING_DATE) AS ACCOUNTING_DATE,
        TRANSACTION_TYPE,

        -- Financial Amounts
        WRITTEN_PREMIUM,
        EARNED_PREMIUM,
        COMMISSION_AMOUNT,
        TAX_AMOUNT,
        FEE_AMOUNT,

        -- Audit Fields
        CREATED_DATE

    FROM source
)

SELECT * FROM standardized
