
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from EKAI.externalized_14_marts.bridge_agency_hierarchy

where not(effective_date <= CURRENT_DATE)


  
  
      
    ) dbt_internal_test