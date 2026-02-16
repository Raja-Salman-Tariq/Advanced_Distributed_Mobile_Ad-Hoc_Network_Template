
    
    

with child as (
    select agency_id as from_field
    from EKAI.externalized_14_marts.bridge_agency_hierarchy
    where agency_id is not null
),

parent as (
    select agency_id as to_field
    from EKAI.externalized_14_marts.dim_agency
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


