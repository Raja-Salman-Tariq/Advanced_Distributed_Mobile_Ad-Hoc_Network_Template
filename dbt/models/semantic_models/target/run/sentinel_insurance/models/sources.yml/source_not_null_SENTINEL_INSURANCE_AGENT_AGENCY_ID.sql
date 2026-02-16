
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select AGENCY_ID
from SENTINEL_INSURANCE.BRONZE.AGENT
where AGENCY_ID is null



  
  
      
    ) dbt_internal_test