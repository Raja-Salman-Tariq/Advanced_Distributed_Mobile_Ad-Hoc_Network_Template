
  create or replace   view EKAI.demoModel_18_marts.fct_claims
  
   as (
    

WITH claims AS (
    SELECT * FROM EKAI.demoModel_18_staging.stg_claims
),

final AS (
    SELECT
        -- Primary Key
        CLAIM_ID,

        -- Business Identifiers
        CLAIM_NUMBER,
        POLICY_ID,

        -- Dates
        LOSS_DATE,
        REPORTED_DATE,
        CLOSED_DATE,

        -- Classification
        LOB_CODE,
        STATUS,
        CAUSE_CODE,

        -- Financial Metrics (for Loss Ratio calculation)
        TOTAL_INCURRED,
        TOTAL_PAID,
        TOTAL_RESERVE,

        -- Flags
        FRAUD_FLAG,
        LITIGATION_FLAG

    FROM claims
)

SELECT * FROM final
  );

