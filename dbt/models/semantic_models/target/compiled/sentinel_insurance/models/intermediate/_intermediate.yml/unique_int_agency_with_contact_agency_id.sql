
    
    

select
    agency_id as unique_field,
    count(*) as n_records

from EKAI.externalized_14_intermediate.int_agency_with_contact
where agency_id is not null
group by agency_id
having count(*) > 1


