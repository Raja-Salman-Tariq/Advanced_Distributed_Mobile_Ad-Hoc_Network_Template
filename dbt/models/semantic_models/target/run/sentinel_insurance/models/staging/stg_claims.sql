
  create or replace   view EKAI.demoModel_18_staging.stg_claims
  
   as (
    

WITH source AS (
    SELECT * FROM SENTINEL_INSURANCE.BRONZE.CLAIM
),

standardized AS (
    SELECT
        -- Primary Key
        CLAIM_ID,

        -- Business Identifiers
        CLAIM_NUMBER,
        POLICY_ID,

        -- Dates (standardized with TRY_TO_DATE for safe parsing)
        TRY_TO_DATE(LOSS_DATE) AS LOSS_DATE,
        TRY_TO_DATE(REPORTED_DATE) AS REPORTED_DATE,
        TRY_TO_DATE(CLOSED_DATE) AS CLOSED_DATE,

        -- Classification Codes (with NULL handling)
        COALESCE(LOB_CODE, 'Unclassified') AS LOB_CODE,
        STATUS,
        CAUSE_CODE,

        -- Financial Metrics
        TOTAL_INCURRED,
        TOTAL_PAID,
        TOTAL_RESERVE,
        DEDUCTIBLE_APPLIED,

        -- Flags
        FRAUD_FLAG,
        LITIGATION_FLAG,
        SUBROGATION_FLAG,

        -- Additional Attributes
        ADJUSTER_ID,
        CATASTROPHE_CODE,
        LOSS_DESCRIPTION,
        CAUSE_DESCRIPTION,
        LOSS_CITY,
        LOSS_STATE,
        LOSS_ZIP,

        -- Audit Fields
        CREATED_DATE,
        UPDATED_DATE

    FROM source
)

SELECT * FROM standardized
  );

