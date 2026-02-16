
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select hierarchy_level
from EKAI.externalized_14_staging.stg_agency_hierarchy
where hierarchy_level is null



  
  
      
    ) dbt_internal_test