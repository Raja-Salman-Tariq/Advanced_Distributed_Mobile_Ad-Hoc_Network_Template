
    
    

select
    agent_id as unique_field,
    count(*) as n_records

from EKAI.externalized_14_staging.stg_agent
where agent_id is not null
group by agent_id
having count(*) > 1


