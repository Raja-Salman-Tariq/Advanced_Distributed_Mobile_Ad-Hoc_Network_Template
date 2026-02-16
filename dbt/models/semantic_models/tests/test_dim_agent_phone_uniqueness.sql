-- Test: Validate that phone is unique across all agents (when not null)
-- Severity: Medium
-- Validation Rule: phone must be unique across all agents
-- Check: COUNT(*) = COUNT(DISTINCT phone)

{{ config(severity='warn') }}

select
    phone,
    count(*) as record_count
from {{ ref('dim_agent') }}
where phone is not null
group by phone
having count(*) > 1
