
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select AGENT_CODE
from SENTINEL_INSURANCE.BRONZE.AGENT
where AGENT_CODE is null



  
  
      
    ) dbt_internal_test