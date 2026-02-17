{% test value_range(model, column_name, min_value=none, max_value=none, sample_size=1000000) %}
{#
    Test for value range validation using sampling.
    Checks if values fall within expected bounds.

    Fails if: Values outside specified range found
    Severity: WARN
#}

WITH sampled_data AS (
    SELECT {{ column_name }}
    FROM {{ model }}
    WHERE {{ column_name }} IS NOT NULL
    LIMIT {{ sample_size }}
)

SELECT
    COUNT(*) AS out_of_range_count,
    MIN({{ column_name }}) AS min_found,
    MAX({{ column_name }}) AS max_found
FROM sampled_data
WHERE 1=1
    {% if min_value is not none %}
    AND {{ column_name }} < {{ min_value }}
    {% endif %}
    {% if max_value is not none %}
    AND {{ column_name }} > {{ max_value }}
    {% endif %}
HAVING COUNT(*) > 0

{% endtest %}
