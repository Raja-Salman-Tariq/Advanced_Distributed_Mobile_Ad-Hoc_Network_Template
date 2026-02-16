
    
    

select
    HIERARCHY_ID as unique_field,
    count(*) as n_records

from SENTINEL_INSURANCE.BRONZE.AGENCY_HIERARCHY
where HIERARCHY_ID is not null
group by HIERARCHY_ID
having count(*) > 1


