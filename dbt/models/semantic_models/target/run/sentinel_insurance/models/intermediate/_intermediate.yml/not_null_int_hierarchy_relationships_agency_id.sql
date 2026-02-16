
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select agency_id
from EKAI.externalized_14_intermediate.int_hierarchy_relationships
where agency_id is null



  
  
      
    ) dbt_internal_test