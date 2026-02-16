
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select EMAIL
from SENTINEL_INSURANCE.BRONZE.AGENT
where EMAIL is null



  
  
      
    ) dbt_internal_test