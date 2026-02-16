
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select is_active
from EKAI.externalized_14_marts.dim_agency
where is_active is null



  
  
      
    ) dbt_internal_test