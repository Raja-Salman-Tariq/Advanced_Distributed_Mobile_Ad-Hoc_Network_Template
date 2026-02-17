{{
    config(
        materialized='view'
    )
}}

WITH agents AS (
    SELECT * FROM {{ ref('stg_agents') }}
),

final AS (
    SELECT
        -- Primary Key
        AGENT_ID,

        -- Business Identifiers
        AGENT_CODE,

        -- Personal Information
        FIRST_NAME,
        LAST_NAME,
        FULL_NAME,

        -- Foreign Keys
        AGENCY_ID,

        -- Commission Information
        COMMISSION_SPLIT,

        -- Status & Licensing
        IS_ACTIVE,
        HIRE_DATE,
        LICENSE_NUMBER,
        LICENSE_STATE

    FROM agents
)

SELECT * FROM final
