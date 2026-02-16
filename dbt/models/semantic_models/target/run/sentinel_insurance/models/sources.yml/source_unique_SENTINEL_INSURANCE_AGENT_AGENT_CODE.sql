
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    AGENT_CODE as unique_field,
    count(*) as n_records

from SENTINEL_INSURANCE.BRONZE.AGENT
where AGENT_CODE is not null
group by AGENT_CODE
having count(*) > 1



  
  
      
    ) dbt_internal_test