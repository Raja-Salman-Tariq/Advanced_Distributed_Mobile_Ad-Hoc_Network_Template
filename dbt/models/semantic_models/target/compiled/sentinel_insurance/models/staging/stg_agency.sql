

with source as (
    select * from SENTINEL_INSURANCE.BRONZE.AGENCY
),

renamed as (
    select
        -- Primary Keys
        AGENCY_ID::NUMBER as agency_id,
        AGENCY_CODE::VARCHAR as agency_code,

        -- Agency Attributes
        AGENCY_NAME::VARCHAR as agency_name,
        AGENCY_TYPE::VARCHAR as agency_type,
        LICENSE_NUMBER::VARCHAR as license_number,
        COMMISSION_RATE::FLOAT as commission_rate,
        IS_ACTIVE::BOOLEAN as is_active,

        -- Contact Information
        ADDRESS::VARCHAR as address,
        CITY::VARCHAR as city,
        STATE_CODE::VARCHAR as state_code,
        ZIP_CODE::VARCHAR as zip_code,
        EMAIL::VARCHAR as email,
        PHONE::VARCHAR as phone,

        -- Date Attributes
        TRY_TO_DATE(APPOINTMENT_DATE) as appointment_date,
        TRY_TO_TIMESTAMP(CREATED_DATE) as created_date

    from source
)

select * from renamed