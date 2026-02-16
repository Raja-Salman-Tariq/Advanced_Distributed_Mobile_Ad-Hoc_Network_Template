-- Test: Validate that no agency has more than 1000 agents (outlier detection)
-- Severity: Low
-- Validation Rule: Agent-Agency Consistency - Count of agents per agency should align with business expectations
-- Check: Validate that no agency has more than 1000 agents

{{ config(severity='warn') }}

select
    ag.agency_id,
    ag.agency_name,
    ag.agency_code,
    count(a.agent_id) as agent_count
from {{ ref('dim_agency') }} ag
left join {{ ref('dim_agent') }} a
    on ag.agency_id = a.agency_id
group by ag.agency_id, ag.agency_name, ag.agency_code
having count(a.agent_id) > 1000
