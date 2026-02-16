
    
    

select
    hierarchy_id as unique_field,
    count(*) as n_records

from EKAI.externalized_14_marts.bridge_agency_hierarchy
where hierarchy_id is not null
group by hierarchy_id
having count(*) > 1


