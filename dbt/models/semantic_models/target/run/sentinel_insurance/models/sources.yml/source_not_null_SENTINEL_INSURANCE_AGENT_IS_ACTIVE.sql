
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select IS_ACTIVE
from SENTINEL_INSURANCE.BRONZE.AGENT
where IS_ACTIVE is null



  
  
      
    ) dbt_internal_test