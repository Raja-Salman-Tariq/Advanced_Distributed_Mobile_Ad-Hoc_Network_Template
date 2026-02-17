
  create or replace   view EKAI.demoModel_18_staging.stg_ref_line_of_business
  
   as (
    

WITH source AS (
    SELECT * FROM SENTINEL_INSURANCE.BRONZE.REF_LINE_OF_BUSINESS
),

standardized AS (
    SELECT
        -- Primary Key
        LOB_ID,

        -- Business Identifiers
        LOB_CODE,
        LOB_NAME,

        -- Classification
        SEGMENT,

        -- Benchmark Metrics
        AVG_PREMIUM,
        CLAIM_FREQUENCY,
        POLICY_WEIGHT,

        -- Status
        ACTIVE_FLAG AS IS_ACTIVE,

        -- Audit Fields
        CREATED_DATE

    FROM source
)

SELECT * FROM standardized
  );

