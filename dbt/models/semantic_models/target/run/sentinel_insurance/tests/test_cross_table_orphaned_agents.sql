
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Test: Validate that no agents reference non-existent agencies
-- Severity: Critical
-- Validation Rule: Orphaned Records Check - No agents should reference non-existent agencies
-- Check: SELECT COUNT(*) FROM dim_agent WHERE agency_id NOT IN (SELECT agency_id FROM dim_agency) should return 0



select
    a.agent_id,
    a.agent_code,
    a.first_name,
    a.last_name,
    a.agency_id as invalid_agency_id
from EKAI.externalized_14_marts.dim_agent a
left join EKAI.externalized_14_marts.dim_agency ag
    on a.agency_id = ag.agency_id
where ag.agency_id is null
  
  
      
    ) dbt_internal_test