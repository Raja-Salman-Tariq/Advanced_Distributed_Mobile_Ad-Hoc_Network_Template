

with source as (
    select * from SENTINEL_INSURANCE.BRONZE.AGENCY_HIERARCHY
),

renamed as (
    select
        -- Primary Key
        HIERARCHY_ID::NUMBER as hierarchy_id,

        -- Foreign Keys
        AGENCY_ID::NUMBER as agency_id,
        PARENT_AGENCY_ID::NUMBER as parent_agency_id,

        -- Hierarchy Attributes
        HIERARCHY_LEVEL::NUMBER as hierarchy_level,
        REGION::VARCHAR as region,

        -- Date Attributes
        TRY_TO_DATE(EFFECTIVE_DATE) as effective_date,
        TRY_TO_TIMESTAMP(CREATED_DATE) as created_date

    from source
)

select * from renamed