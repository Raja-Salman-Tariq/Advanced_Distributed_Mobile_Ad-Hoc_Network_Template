-- Test: Validate that all agency_id values in dim_agency are referenced by bridge_agency_hierarchy
-- Severity: High
-- Validation Rule: Referential Integrity - agencies should be in hierarchy
-- Note: This is an informational check - some agencies may not be in hierarchy

{{ config(severity='warn') }}

select
    a.agency_id,
    a.agency_name,
    a.agency_code
from {{ ref('dim_agency') }} a
left join {{ ref('bridge_agency_hierarchy') }} h
    on a.agency_id = h.agency_id
where h.hierarchy_id is null
  and a.is_active = true
-- Only flag active agencies not in hierarchy as potential data quality issues
