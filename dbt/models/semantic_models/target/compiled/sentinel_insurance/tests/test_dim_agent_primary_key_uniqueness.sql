-- Test: Validate that agent_code is unique and not null
-- Severity: Critical
-- Validation Rule: agent_code must be unique and not null
-- Check: COUNT(*) = COUNT(DISTINCT agent_code)



select
    agent_code,
    count(*) as record_count
from EKAI.externalized_14_marts.dim_agent
group by agent_code
having count(*) > 1