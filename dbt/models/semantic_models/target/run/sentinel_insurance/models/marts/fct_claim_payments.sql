
  create or replace   view EKAI.demoModel_18_marts.fct_claim_payments
  
   as (
    

WITH claim_payments AS (
    SELECT * FROM EKAI.demoModel_18_staging.stg_claim_payments
),

final AS (
    SELECT
        -- Primary Key
        PAYMENT_ID,

        -- Foreign Keys
        CLAIM_ID,

        -- Transaction Details
        PAYMENT_DATE,
        PAYMENT_AMOUNT,
        PAYMENT_TYPE,
        PAYMENT_METHOD,

        -- Payee Information
        PAYEE_NAME,
        PAYEE_TYPE

    FROM claim_payments
)

SELECT * FROM final
  );

