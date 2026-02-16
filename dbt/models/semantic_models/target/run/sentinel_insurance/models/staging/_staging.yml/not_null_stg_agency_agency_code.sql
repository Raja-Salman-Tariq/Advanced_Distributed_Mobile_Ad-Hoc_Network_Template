
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select agency_code
from EKAI.externalized_14_staging.stg_agency
where agency_code is null



  
  
      
    ) dbt_internal_test