
  create or replace   view EKAI.externalized_14_intermediate.int_hierarchy_relationships
  
   as (
    

with stg_hierarchy as (
    select * from EKAI.externalized_14_staging.stg_agency_hierarchy
),

stg_agency as (
    select * from EKAI.externalized_14_staging.stg_agency
),

enriched as (
    select
        h.hierarchy_id,
        h.agency_id,
        h.parent_agency_id,
        h.hierarchy_level,
        h.region,
        h.effective_date,
        h.created_date,

        -- Child Agency Details
        a.agency_code as child_agency_code,
        a.agency_name as child_agency_name,
        a.agency_type as child_agency_type,
        a.is_active as child_is_active,

        -- Parent Agency Details (will be null for top-level agencies)
        p.agency_code as parent_agency_code,
        p.agency_name as parent_agency_name,
        p.agency_type as parent_agency_type,
        p.is_active as parent_is_active,

        -- Calculated Fields
        CASE
            WHEN h.parent_agency_id IS NULL THEN 'TOP_LEVEL'
            ELSE 'SUBORDINATE'
        END as hierarchy_position,

        -- Data Quality Flags
        CASE
            WHEN h.agency_id = h.parent_agency_id THEN TRUE
            ELSE FALSE
        END as is_self_referencing,
        CASE
            WHEN h.effective_date > CURRENT_DATE THEN TRUE
            ELSE FALSE
        END as is_future_effective,
        CASE
            WHEN h.hierarchy_level < 1 OR h.hierarchy_level > 3 THEN TRUE
            ELSE FALSE
        END as is_invalid_level

    from stg_hierarchy h
    left join stg_agency a
        on h.agency_id = a.agency_id
    left join stg_agency p
        on h.parent_agency_id = p.agency_id
)

select * from enriched
  );

