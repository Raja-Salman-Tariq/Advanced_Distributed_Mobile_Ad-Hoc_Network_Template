
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select LICENSE_NUMBER
from SENTINEL_INSURANCE.BRONZE.AGENT
where LICENSE_NUMBER is null



  
  
      
    ) dbt_internal_test