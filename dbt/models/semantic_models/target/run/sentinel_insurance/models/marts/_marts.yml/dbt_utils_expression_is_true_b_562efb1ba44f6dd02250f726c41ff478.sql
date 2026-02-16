
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from EKAI.externalized_14_marts.bridge_agency_hierarchy

where not(agency_id != parent_agency_id OR parent_agency_id IS NULL)


  
  
      
    ) dbt_internal_test