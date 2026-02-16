
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select agency_code
from EKAI.externalized_14_intermediate.int_agency_with_contact
where agency_code is null



  
  
      
    ) dbt_internal_test