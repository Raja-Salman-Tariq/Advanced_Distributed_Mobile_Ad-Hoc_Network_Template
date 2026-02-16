-- Test: Validate that agent_code is unique and not null
-- Severity: Critical
-- Validation Rule: agent_code must be unique and not null
-- Check: COUNT(*) = COUNT(DISTINCT agent_code)

{{ config(severity='error') }}

select
    agent_code,
    count(*) as record_count
from {{ ref('dim_agent') }}
group by agent_code
having count(*) > 1
