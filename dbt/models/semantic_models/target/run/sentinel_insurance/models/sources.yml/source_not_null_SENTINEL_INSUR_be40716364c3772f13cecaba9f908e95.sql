
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select HIERARCHY_LEVEL
from SENTINEL_INSURANCE.BRONZE.AGENCY_HIERARCHY
where HIERARCHY_LEVEL is null



  
  
      
    ) dbt_internal_test