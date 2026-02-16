
  
    

create or replace transient table EKAI.externalized_14_marts.dim_agency
    

    
    as (

with int_agency as (
    select * from EKAI.externalized_14_intermediate.int_agency_with_contact
),

final as (
    select
        -- Primary Key
        agency_id,
        agency_code,

        -- Agency Attributes
        agency_name,
        agency_type,
        license_number,
        validated_commission_rate as commission_rate,
        is_active,

        -- Contact Information
        address,
        city,
        state_code,
        zip_code,
        email,
        phone,

        -- Date Attributes
        appointment_date,
        created_date

    from int_agency
    where agency_id IS NOT NULL
      and agency_code IS NOT NULL
      and agency_name IS NOT NULL
      and license_number IS NOT NULL
)

select * from final
    )
;


  