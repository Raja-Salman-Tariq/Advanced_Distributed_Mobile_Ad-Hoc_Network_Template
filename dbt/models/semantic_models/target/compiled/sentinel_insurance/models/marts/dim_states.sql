

WITH states AS (
    SELECT * FROM EKAI.demoModel_18_staging.stg_ref_states
),

final AS (
    SELECT
        -- Primary Key
        STATE_ID,

        -- Business Identifiers
        STATE_CODE,
        STATE_NAME,

        -- Geographic Classification
        REGION,

        -- Regulatory Attributes
        NO_FAULT_AUTO

    FROM states
)

SELECT * FROM final