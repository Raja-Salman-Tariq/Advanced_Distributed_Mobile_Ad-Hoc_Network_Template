
    
    

select
    agent_id as unique_field,
    count(*) as n_records

from EKAI.externalized_14_intermediate.int_agent_with_license
where agent_id is not null
group by agent_id
having count(*) > 1


