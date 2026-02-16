
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    AGENCY_CODE as unique_field,
    count(*) as n_records

from SENTINEL_INSURANCE.BRONZE.AGENCY
where AGENCY_CODE is not null
group by AGENCY_CODE
having count(*) > 1



  
  
      
    ) dbt_internal_test