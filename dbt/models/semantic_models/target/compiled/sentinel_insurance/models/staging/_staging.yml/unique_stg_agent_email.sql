
    
    

select
    email as unique_field,
    count(*) as n_records

from EKAI.externalized_14_staging.stg_agent
where email is not null
group by email
having count(*) > 1


