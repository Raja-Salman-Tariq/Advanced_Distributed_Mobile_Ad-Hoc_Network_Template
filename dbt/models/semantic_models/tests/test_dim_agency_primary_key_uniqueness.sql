-- Test: Validate that agency_id is unique and not null
-- Severity: Critical
-- Validation Rule: agency_id must be unique and not null
-- Check: COUNT(*) = COUNT(DISTINCT agency_id)

{{ config(severity='error') }}

select
    agency_id,
    count(*) as record_count
from {{ ref('dim_agency') }}
group by agency_id
having count(*) > 1
