

with stg_agency as (
    select * from EKAI.externalized_14_staging.stg_agency
),

enriched as (
    select
        -- Primary Keys
        agency_id,
        agency_code,

        -- Agency Attributes
        agency_name,
        agency_type,
        license_number,
        commission_rate,
        is_active,

        -- Formatted Contact Information
        TRIM(UPPER(address)) as address,
        TRIM(UPPER(city)) as city,
        UPPER(state_code) as state_code,
        zip_code,
        LOWER(TRIM(email)) as email,
        REGEXP_REPLACE(phone, '[^0-9]', '') as phone,

        -- Calculated Fields
        CONCAT(city, ', ', state_code) as city_state,
        CASE
            WHEN commission_rate >= 0 AND commission_rate <= 1 THEN commission_rate
            ELSE NULL
        END as validated_commission_rate,

        -- Date Attributes
        appointment_date,
        created_date,

        -- Audit Flags
        CASE
            WHEN email IS NOT NULL AND REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$')
            THEN TRUE
            ELSE FALSE
        END as has_valid_email,
        CASE
            WHEN phone IS NOT NULL AND LENGTH(REGEXP_REPLACE(phone, '[^0-9]', '')) = 10
            THEN TRUE
            ELSE FALSE
        END as has_valid_phone

    from stg_agency
)

select * from enriched