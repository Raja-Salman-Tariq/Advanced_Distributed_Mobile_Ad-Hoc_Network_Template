
    
    

select
    AGENCY_ID as unique_field,
    count(*) as n_records

from SENTINEL_INSURANCE.BRONZE.AGENCY
where AGENCY_ID is not null
group by AGENCY_ID
having count(*) > 1


