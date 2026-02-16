
    
    

select
    hierarchy_id as unique_field,
    count(*) as n_records

from EKAI.externalized_14_intermediate.int_hierarchy_relationships
where hierarchy_id is not null
group by hierarchy_id
having count(*) > 1


