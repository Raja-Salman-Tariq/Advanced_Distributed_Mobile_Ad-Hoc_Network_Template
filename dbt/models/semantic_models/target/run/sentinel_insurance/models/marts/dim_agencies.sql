
  create or replace   view EKAI.demoModel_18_marts.dim_agencies
  
   as (
    

WITH agencies AS (
    SELECT * FROM EKAI.demoModel_18_staging.stg_agencies
),

final AS (
    SELECT
        -- Primary Key
        AGENCY_ID,

        -- Business Identifiers
        AGENCY_CODE,
        AGENCY_NAME,

        -- Agency Details
        AGENCY_TYPE,
        COMMISSION_RATE,

        -- Status
        IS_ACTIVE,

        -- Location
        STATE_CODE,
        CITY

    FROM agencies
)

SELECT * FROM final
  );

