
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select agent_code
from EKAI.externalized_14_staging.stg_agent
where agent_code is null



  
  
      
    ) dbt_internal_test