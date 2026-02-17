
  create or replace   view EKAI.demoModel_18_staging.stg_ref_states
  
   as (
    

WITH source AS (
    SELECT * FROM SENTINEL_INSURANCE.BRONZE.REF_STATE
),

standardized AS (
    SELECT
        -- Primary Key
        STATE_ID,

        -- Business Identifiers
        STATE_CODE,
        STATE_NAME,

        -- Geographic Classification
        REGION,
        TERRITORY_CODE,

        -- Regulatory Attributes
        NO_FAULT_AUTO,
        WC_MONOPOLISTIC,

        -- Audit Fields
        CREATED_DATE

    FROM source
)

SELECT * FROM standardized
  );

