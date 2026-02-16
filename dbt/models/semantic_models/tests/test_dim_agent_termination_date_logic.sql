-- Test: Validate that if termination_date is populated, is_active should be FALSE
-- Severity: Medium
-- Validation Rule: Active Status Logic - terminated agents should not be active
-- Check: termination_date IS NULL OR is_active = FALSE

{{ config(severity='warn') }}

select
    agent_id,
    agent_code,
    first_name,
    last_name,
    termination_date,
    is_active
from {{ ref('dim_agent') }}
where termination_date is not null
  and is_active = true
