
    
    

select
    AGENT_CODE as unique_field,
    count(*) as n_records

from SENTINEL_INSURANCE.BRONZE.AGENT
where AGENT_CODE is not null
group by AGENT_CODE
having count(*) > 1


