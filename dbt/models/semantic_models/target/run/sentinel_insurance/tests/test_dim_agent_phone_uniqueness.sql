
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Test: Validate that phone is unique across all agents (when not null)
-- Severity: Medium
-- Validation Rule: phone must be unique across all agents
-- Check: COUNT(*) = COUNT(DISTINCT phone)



select
    phone,
    count(*) as record_count
from EKAI.externalized_14_marts.dim_agent
where phone is not null
group by phone
having count(*) > 1
  
  
      
    ) dbt_internal_test