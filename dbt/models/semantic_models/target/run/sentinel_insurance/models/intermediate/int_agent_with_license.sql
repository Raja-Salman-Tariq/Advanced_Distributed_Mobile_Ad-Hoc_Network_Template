
  create or replace   view EKAI.externalized_14_intermediate.int_agent_with_license
  
   as (
    

with stg_agent as (
    select * from EKAI.externalized_14_staging.stg_agent
),

enriched as (
    select
        -- Primary Keys
        agent_id,
        agent_code,

        -- Agent Personal Information
        TRIM(first_name) as first_name,
        TRIM(last_name) as last_name,
        CONCAT(TRIM(first_name), ' ', TRIM(last_name)) as full_name,
        LOWER(TRIM(email)) as email,
        REGEXP_REPLACE(phone, '[^0-9]', '') as phone,

        -- License Information
        license_number,
        UPPER(license_state) as license_state,
        license_expiration,

        -- License Status Calculations
        CASE
            WHEN license_expiration IS NULL THEN 'UNKNOWN'
            WHEN license_expiration < CURRENT_DATE THEN 'EXPIRED'
            WHEN license_expiration <= DATEADD(day, 90, CURRENT_DATE) THEN 'EXPIRING_SOON'
            ELSE 'VALID'
        END as license_status,
        CASE
            WHEN license_expiration IS NOT NULL
            THEN DATEDIFF(day, CURRENT_DATE, license_expiration)
            ELSE NULL
        END as days_until_expiration,

        -- Employment Attributes
        CASE
            WHEN commission_split >= 0 AND commission_split <= 1 THEN commission_split
            ELSE NULL
        END as validated_commission_split,
        is_active,
        hire_date,
        termination_date,

        -- Employment Duration Calculations
        CASE
            WHEN is_active = TRUE AND hire_date IS NOT NULL
            THEN DATEDIFF(day, hire_date, CURRENT_DATE)
            WHEN is_active = FALSE AND hire_date IS NOT NULL AND termination_date IS NOT NULL
            THEN DATEDIFF(day, hire_date, termination_date)
            ELSE NULL
        END as tenure_days,

        -- Data Quality Flags
        CASE
            WHEN termination_date IS NOT NULL AND termination_date <= hire_date
            THEN TRUE
            ELSE FALSE
        END as has_invalid_dates,
        CASE
            WHEN is_active = TRUE AND termination_date IS NOT NULL
            THEN TRUE
            ELSE FALSE
        END as has_status_mismatch,

        -- Foreign Key
        agency_id,

        -- Audit
        created_date

    from stg_agent
)

select * from enriched
  );

