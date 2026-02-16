-- Test: Validate that hierarchy_id is unique and not null
-- Severity: Critical
-- Validation Rule: hierarchy_id must be unique and not null
-- Check: COUNT(*) = COUNT(DISTINCT hierarchy_id)

{{ config(severity='error') }}

select
    hierarchy_id,
    count(*) as record_count
from {{ ref('bridge_agency_hierarchy') }}
group by hierarchy_id
having count(*) > 1
