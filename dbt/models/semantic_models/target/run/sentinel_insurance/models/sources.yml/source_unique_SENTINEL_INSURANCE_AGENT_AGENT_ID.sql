
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    AGENT_ID as unique_field,
    count(*) as n_records

from SENTINEL_INSURANCE.BRONZE.AGENT
where AGENT_ID is not null
group by AGENT_ID
having count(*) > 1



  
  
      
    ) dbt_internal_test