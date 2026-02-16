
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select agency_name
from EKAI.externalized_14_marts.dim_agency
where agency_name is null



  
  
      
    ) dbt_internal_test