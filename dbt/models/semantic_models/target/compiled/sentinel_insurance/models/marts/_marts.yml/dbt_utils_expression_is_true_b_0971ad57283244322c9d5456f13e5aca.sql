



select
    1
from EKAI.externalized_14_marts.bridge_agency_hierarchy

where not(effective_date <= CURRENT_DATE)

