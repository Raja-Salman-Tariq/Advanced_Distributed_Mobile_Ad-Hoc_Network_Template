
  create or replace   view EKAI.externalized_14_staging.stg_agent
  
   as (
    

with source as (
    select * from SENTINEL_INSURANCE.BRONZE.AGENT
),

renamed as (
    select
        -- Primary Keys
        AGENT_ID::NUMBER as agent_id,
        AGENT_CODE::VARCHAR as agent_code,

        -- Agent Personal Information
        FIRST_NAME::VARCHAR as first_name,
        LAST_NAME::VARCHAR as last_name,
        EMAIL::VARCHAR as email,
        PHONE::VARCHAR as phone,

        -- License Information
        LICENSE_NUMBER::VARCHAR as license_number,
        LICENSE_STATE::VARCHAR as license_state,
        TRY_TO_DATE(LICENSE_EXPIRATION) as license_expiration,

        -- Employment Attributes
        COMMISSION_SPLIT::FLOAT as commission_split,
        IS_ACTIVE::BOOLEAN as is_active,
        TRY_TO_DATE(HIRE_DATE) as hire_date,
        TRY_TO_DATE(TERMINATION_DATE) as termination_date,

        -- Foreign Key
        AGENCY_ID::NUMBER as agency_id,

        -- Audit
        TRY_TO_TIMESTAMP(CREATED_DATE) as created_date

    from source
),

-- Deduplicate by email, keeping the most recent record
-- This ensures email uniqueness as required by business rules
deduplicated as (
    select *,
        ROW_NUMBER() OVER (
            PARTITION BY email
            ORDER BY created_date DESC, agent_id DESC
        ) as row_num
    from renamed
    where email IS NOT NULL
),

-- Combine deduplicated records with null emails (preserve them)
final as (
    select
        agent_id,
        agent_code,
        first_name,
        last_name,
        email,
        phone,
        license_number,
        license_state,
        license_expiration,
        commission_split,
        is_active,
        hire_date,
        termination_date,
        agency_id,
        created_date
    from deduplicated
    where row_num = 1

    UNION ALL

    select
        agent_id,
        agent_code,
        first_name,
        last_name,
        email,
        phone,
        license_number,
        license_state,
        license_expiration,
        commission_split,
        is_active,
        hire_date,
        termination_date,
        agency_id,
        created_date
    from renamed
    where email IS NULL
)

select * from final
  );

