

with meet_condition as(
  select *
  from EKAI.externalized_14_marts.bridge_agency_hierarchy
),

validation_errors as (
  select *
  from meet_condition
  where
    -- never true, defaults to an empty result set. Exists to ensure any combo of the `or` clauses below succeeds
    1 = 2
    -- records with a value >= min_value are permitted. The `not` flips this to find records that don't meet the rule.
    or not hierarchy_level >= 1
    -- records with a value <= max_value are permitted. The `not` flips this to find records that don't meet the rule.
    or not hierarchy_level <= 3
)

select *
from validation_errors

