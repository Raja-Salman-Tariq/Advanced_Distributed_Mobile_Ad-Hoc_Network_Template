
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select FIRST_NAME
from SENTINEL_INSURANCE.BRONZE.AGENT
where FIRST_NAME is null



  
  
      
    ) dbt_internal_test