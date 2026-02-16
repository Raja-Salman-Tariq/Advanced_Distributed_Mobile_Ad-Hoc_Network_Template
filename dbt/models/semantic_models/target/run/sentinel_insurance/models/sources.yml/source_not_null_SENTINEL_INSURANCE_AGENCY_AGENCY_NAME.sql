
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select AGENCY_NAME
from SENTINEL_INSURANCE.BRONZE.AGENCY
where AGENCY_NAME is null



  
  
      
    ) dbt_internal_test