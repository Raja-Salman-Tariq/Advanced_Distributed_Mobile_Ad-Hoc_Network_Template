

WITH cause_of_loss AS (
    SELECT * FROM EKAI.demoModel_18_staging.stg_ref_cause_of_loss
),

final AS (
    SELECT
        -- Primary Key
        CAUSE_ID,

        -- Business Identifiers
        CAUSE_CODE,
        CAUSE_NAME,

        -- Classification
        CAUSE_CATEGORY,

        -- Statistical Metrics
        AVG_SEVERITY

    FROM cause_of_loss
)

SELECT * FROM final