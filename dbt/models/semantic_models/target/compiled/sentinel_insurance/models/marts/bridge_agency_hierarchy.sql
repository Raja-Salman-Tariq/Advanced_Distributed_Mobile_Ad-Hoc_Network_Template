

with int_hierarchy as (
    select * from EKAI.externalized_14_intermediate.int_hierarchy_relationships
),

final as (
    select
        -- Primary Key
        hierarchy_id,

        -- Foreign Keys
        agency_id,
        parent_agency_id,

        -- Hierarchy Attributes
        hierarchy_level,
        region,

        -- Date Attributes
        effective_date,
        created_date

    from int_hierarchy
    where hierarchy_id IS NOT NULL
      and agency_id IS NOT NULL
      and hierarchy_level IS NOT NULL
      and effective_date IS NOT NULL
      -- Exclude invalid records
      and is_self_referencing = FALSE
      and is_invalid_level = FALSE
)

select * from final