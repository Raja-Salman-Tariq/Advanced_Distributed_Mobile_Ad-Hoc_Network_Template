
    
    

select
    phone as unique_field,
    count(*) as n_records

from EKAI.externalized_14_staging.stg_agent
where phone is not null
group by phone
having count(*) > 1


