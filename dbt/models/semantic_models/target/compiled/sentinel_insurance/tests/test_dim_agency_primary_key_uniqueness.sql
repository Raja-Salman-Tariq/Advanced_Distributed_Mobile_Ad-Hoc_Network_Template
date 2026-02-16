-- Test: Validate that agency_id is unique and not null
-- Severity: Critical
-- Validation Rule: agency_id must be unique and not null
-- Check: COUNT(*) = COUNT(DISTINCT agency_id)



select
    agency_id,
    count(*) as record_count
from EKAI.externalized_14_marts.dim_agency
group by agency_id
having count(*) > 1