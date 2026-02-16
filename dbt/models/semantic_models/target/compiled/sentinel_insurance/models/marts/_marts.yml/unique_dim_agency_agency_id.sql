
    
    

select
    agency_id as unique_field,
    count(*) as n_records

from EKAI.externalized_14_marts.dim_agency
where agency_id is not null
group by agency_id
having count(*) > 1


