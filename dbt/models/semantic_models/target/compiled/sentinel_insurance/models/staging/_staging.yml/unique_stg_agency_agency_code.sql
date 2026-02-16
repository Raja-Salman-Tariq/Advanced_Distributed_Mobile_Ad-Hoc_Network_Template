
    
    

select
    agency_code as unique_field,
    count(*) as n_records

from EKAI.externalized_14_staging.stg_agency
where agency_code is not null
group by agency_code
having count(*) > 1


