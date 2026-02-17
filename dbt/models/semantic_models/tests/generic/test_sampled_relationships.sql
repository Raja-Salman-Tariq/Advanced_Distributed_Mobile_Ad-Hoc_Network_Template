{% test sampled_relationships(model, column_name, to, field, sample_size=1000000) %}
{#
    Test for referential integrity using stratified sampling.
    Efficiently checks foreign key relationships without full table scan.

    Fails if: Orphaned records found (child records without parent)
    Severity: ERROR or WARN depending on relationship criticality
#}

WITH child_sample AS (
    SELECT DISTINCT {{ column_name }}
    FROM {{ model }}
    WHERE {{ column_name }} IS NOT NULL
    LIMIT {{ sample_size }}
),

parent_keys AS (
    SELECT {{ field }}
    FROM {{ to }}
),

orphaned_records AS (
    SELECT c.{{ column_name }}
    FROM child_sample c
    LEFT JOIN parent_keys p
        ON c.{{ column_name }} = p.{{ field }}
    WHERE p.{{ field }} IS NULL
)

SELECT
    COUNT(*) AS orphaned_count
FROM orphaned_records
HAVING COUNT(*) > 0

{% endtest %}
