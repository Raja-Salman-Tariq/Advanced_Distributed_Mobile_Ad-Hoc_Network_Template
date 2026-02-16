
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select agency_id as from_field
    from EKAI.externalized_14_staging.stg_agent
    where agency_id is not null
),

parent as (
    select agency_id as to_field
    from EKAI.externalized_14_staging.stg_agency
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test