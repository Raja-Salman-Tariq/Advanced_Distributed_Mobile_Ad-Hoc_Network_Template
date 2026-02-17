
  create or replace   view EKAI.demoModel_18_marts.dim_coverage_codes
  
   as (
    

WITH coverage_codes AS (
    SELECT * FROM EKAI.demoModel_18_staging.stg_ref_coverage_codes
),

final AS (
    SELECT
        -- Primary Key
        COVERAGE_ID,

        -- Business Identifiers
        COVERAGE_CODE,
        COVERAGE_NAME,

        -- Classification
        LOB_CODE,

        -- Default Terms
        DEFAULT_LIMIT,
        DEFAULT_DEDUCTIBLE,

        -- Requirements
        IS_REQUIRED

    FROM coverage_codes
)

SELECT * FROM final
  );

