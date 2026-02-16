
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select EFFECTIVE_DATE
from SENTINEL_INSURANCE.BRONZE.AGENCY_HIERARCHY
where EFFECTIVE_DATE is null



  
  
      
    ) dbt_internal_test