
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select effective_date
from EKAI.externalized_14_staging.stg_agency_hierarchy
where effective_date is null



  
  
      
    ) dbt_internal_test