
  
    

create or replace transient table EKAI.externalized_14_marts.dim_agent
    

    
    as (

with int_agent as (
    select * from EKAI.externalized_14_intermediate.int_agent_with_license
),

stg_agency as (
    select
        agency_id,
        agency_name
    from EKAI.externalized_14_staging.stg_agency
),

final as (
    select
        -- Primary Keys
        a.agent_id,
        a.agent_code,

        -- Agent Personal Information
        a.first_name,
        a.last_name,
        a.email,
        a.phone,

        -- License Information
        a.license_number,
        a.license_state,
        a.license_expiration,

        -- Employment Attributes
        a.validated_commission_split as commission_split,
        a.is_active,
        a.hire_date,
        a.termination_date,

        -- Foreign Key and Agency Details
        a.agency_id,
        ag.agency_name,

        -- Audit
        a.created_date

    from int_agent a
    inner join stg_agency ag
        on a.agency_id = ag.agency_id
    where a.agent_id IS NOT NULL
      and a.agent_code IS NOT NULL
      and a.first_name IS NOT NULL
      and a.last_name IS NOT NULL
      and a.email IS NOT NULL
      and a.license_number IS NOT NULL
      and a.is_active IS NOT NULL
      and a.agency_id IS NOT NULL
)

select * from final
    )
;


  