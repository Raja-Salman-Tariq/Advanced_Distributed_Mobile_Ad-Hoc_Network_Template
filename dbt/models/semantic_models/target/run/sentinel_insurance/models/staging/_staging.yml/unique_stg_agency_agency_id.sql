
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    agency_id as unique_field,
    count(*) as n_records

from EKAI.externalized_14_staging.stg_agency
where agency_id is not null
group by agency_id
having count(*) > 1



  
  
      
    ) dbt_internal_test