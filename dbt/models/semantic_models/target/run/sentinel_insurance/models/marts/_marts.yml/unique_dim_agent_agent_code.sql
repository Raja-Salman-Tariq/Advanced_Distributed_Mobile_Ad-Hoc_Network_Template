
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    agent_code as unique_field,
    count(*) as n_records

from EKAI.externalized_14_marts.dim_agent
where agent_code is not null
group by agent_code
having count(*) > 1



  
  
      
    ) dbt_internal_test