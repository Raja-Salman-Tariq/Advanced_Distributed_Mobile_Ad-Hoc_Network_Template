{% test sampled_not_null(model, column_name, sample_size=1000000) %}
{#
    Test for NOT NULL constraint using sampling for efficiency.
    Samples up to 1M rows and checks for null values.

    Fails if: Any NULL values found in sample
    Severity: ERROR
#}

WITH sampled_data AS (
    SELECT {{ column_name }}
    FROM {{ model }}
    LIMIT {{ sample_size }}
)

SELECT
    COUNT(*) AS null_count
FROM sampled_data
WHERE {{ column_name }} IS NULL
HAVING COUNT(*) > 0

{% endtest %}
