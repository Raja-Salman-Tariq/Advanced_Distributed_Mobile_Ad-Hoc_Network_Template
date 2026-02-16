
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select LAST_NAME
from SENTINEL_INSURANCE.BRONZE.AGENT
where LAST_NAME is null



  
  
      
    ) dbt_internal_test