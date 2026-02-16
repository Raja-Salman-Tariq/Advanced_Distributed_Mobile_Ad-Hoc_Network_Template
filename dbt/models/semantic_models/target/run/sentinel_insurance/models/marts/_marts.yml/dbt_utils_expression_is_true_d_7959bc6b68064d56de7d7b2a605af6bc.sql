
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from EKAI.externalized_14_marts.dim_agent

where not(termination_date IS NULL OR termination_date > hire_date)


  
  
      
    ) dbt_internal_test