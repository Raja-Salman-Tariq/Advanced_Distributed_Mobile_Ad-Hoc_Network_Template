
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Test: Validate that no agency has more than 1000 agents (outlier detection)
-- Severity: Low
-- Validation Rule: Agent-Agency Consistency - Count of agents per agency should align with business expectations
-- Check: Validate that no agency has more than 1000 agents



select
    ag.agency_id,
    ag.agency_name,
    ag.agency_code,
    count(a.agent_id) as agent_count
from EKAI.externalized_14_marts.dim_agency ag
left join EKAI.externalized_14_marts.dim_agent a
    on ag.agency_id = a.agency_id
group by ag.agency_id, ag.agency_name, ag.agency_code
having count(a.agent_id) > 1000
  
  
      
    ) dbt_internal_test