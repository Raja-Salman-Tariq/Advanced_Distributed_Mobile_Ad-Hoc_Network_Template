
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select license_number
from EKAI.externalized_14_staging.stg_agent
where license_number is null



  
  
      
    ) dbt_internal_test