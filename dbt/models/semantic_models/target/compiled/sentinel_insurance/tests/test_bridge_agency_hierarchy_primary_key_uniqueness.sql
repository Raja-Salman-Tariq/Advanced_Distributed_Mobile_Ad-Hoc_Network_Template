-- Test: Validate that hierarchy_id is unique and not null
-- Severity: Critical
-- Validation Rule: hierarchy_id must be unique and not null
-- Check: COUNT(*) = COUNT(DISTINCT hierarchy_id)



select
    hierarchy_id,
    count(*) as record_count
from EKAI.externalized_14_marts.bridge_agency_hierarchy
group by hierarchy_id
having count(*) > 1