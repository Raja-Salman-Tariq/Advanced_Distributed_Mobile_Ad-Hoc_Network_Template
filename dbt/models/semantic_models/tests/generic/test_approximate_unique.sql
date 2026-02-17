{% test approximate_unique(model, column_name, sample_size=1000000) %}
{#
    Test for approximate uniqueness using HyperLogLog for cardinality estimation.
    This test uses probabilistic approach to validate primary key uniqueness
    without scanning all rows, ensuring efficient execution on large datasets.

    Fails if: HLL_COUNT(column) != COUNT(*) within sample
    Severity: ERROR (for primary keys)
#}

WITH sampled_data AS (
    SELECT {{ column_name }}
    FROM {{ model }}
    {% if sample_size %}
    LIMIT {{ sample_size }}
    {% endif %}
),

cardinality_check AS (
    SELECT
        COUNT(*) AS total_rows,
        HLL({{ column_name }}) AS hll_cardinality,
        COUNT(DISTINCT {{ column_name }}) AS distinct_count
    FROM sampled_data
),

validation AS (
    SELECT
        total_rows,
        hll_cardinality,
        distinct_count,
        total_rows - hll_cardinality AS duplicate_estimate,
        -- Allow 1% margin for HLL approximation
        ABS(total_rows - hll_cardinality) / NULLIF(total_rows, 0) AS error_rate
    FROM cardinality_check
)

SELECT *
FROM validation
WHERE error_rate > 0.01  -- Fail if more than 1% error (indicating duplicates)
   OR duplicate_estimate > 0

{% endtest %}
