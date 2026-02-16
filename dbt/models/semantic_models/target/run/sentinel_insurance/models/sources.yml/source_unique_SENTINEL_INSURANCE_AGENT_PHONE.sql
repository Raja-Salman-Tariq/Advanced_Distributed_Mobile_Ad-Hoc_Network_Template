
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    PHONE as unique_field,
    count(*) as n_records

from SENTINEL_INSURANCE.BRONZE.AGENT
where PHONE is not null
group by PHONE
having count(*) > 1



  
  
      
    ) dbt_internal_test