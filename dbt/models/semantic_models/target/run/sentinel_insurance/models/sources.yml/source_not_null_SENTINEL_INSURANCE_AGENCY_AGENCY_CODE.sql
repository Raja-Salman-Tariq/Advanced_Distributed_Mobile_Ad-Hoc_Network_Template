
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select AGENCY_CODE
from SENTINEL_INSURANCE.BRONZE.AGENCY
where AGENCY_CODE is null



  
  
      
    ) dbt_internal_test