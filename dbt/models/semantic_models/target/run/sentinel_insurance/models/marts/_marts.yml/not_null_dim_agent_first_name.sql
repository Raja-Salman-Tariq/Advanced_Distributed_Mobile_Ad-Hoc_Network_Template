
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select first_name
from EKAI.externalized_14_marts.dim_agent
where first_name is null



  
  
      
    ) dbt_internal_test