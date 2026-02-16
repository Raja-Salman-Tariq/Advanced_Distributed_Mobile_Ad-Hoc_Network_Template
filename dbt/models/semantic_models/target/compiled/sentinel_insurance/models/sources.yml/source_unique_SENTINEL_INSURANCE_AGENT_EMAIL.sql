
    
    

select
    EMAIL as unique_field,
    count(*) as n_records

from SENTINEL_INSURANCE.BRONZE.AGENT
where EMAIL is not null
group by EMAIL
having count(*) > 1


