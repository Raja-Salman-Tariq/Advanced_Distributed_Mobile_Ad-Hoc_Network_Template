
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Test: Validate that all agency_id values in dim_agency are referenced by dim_agent
-- Severity: High
-- Validation Rule: Referential Integrity - agencies should have agents referencing them
-- Note: This is an informational check - orphaned agencies may exist by design



select
    a.agency_id,
    a.agency_name,
    a.agency_code
from EKAI.externalized_14_marts.dim_agency a
left join EKAI.externalized_14_marts.dim_agent ag
    on a.agency_id = ag.agency_id
where ag.agent_id is null
  and a.is_active = true
-- Only flag active agencies with no agents as potential data quality issues
  
  
      
    ) dbt_internal_test