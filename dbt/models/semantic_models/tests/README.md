# Sentinel Insurance Analytics - dbt Tests

This directory contains custom singular tests that complement the schema tests defined in `models/marts/_marts_tests.yml`.

## Test Files

### Efficiency & Primary Keys
- **test_primary_key_uniqueness_efficient.sql**
  - Uses HyperLogLog (HLL) for efficient primary key uniqueness validation
  - Validates all mart models' PKs in a single test
  - Severity: ERROR

### Business Logic
- **test_agent_net_revenue_calculation.sql**
  - Validates AGENT_NET_REVENUE = COMMISSION_AMOUNT × COMMISSION_SPLIT
  - Uses sampling (10k rows) for efficiency
  - Severity: WARN

### Code Consistency
- **test_code_consistency_lob.sql**
  - Validates LOB_CODE values exist in dim_line_of_business
  - Samples 100k rows from fct_claims, 50k from dim_policies
  - Severity: WARN

- **test_code_consistency_state.sql**
  - Validates STATE_CODE values exist in dim_states
  - Samples 50k rows from dim_policies
  - Severity: WARN

- **test_code_consistency_cause.sql**
  - Validates CAUSE_CODE values exist in dim_cause_of_loss
  - Samples 100k rows from fct_claims
  - Severity: WARN

### Cross-Model Consistency
- **test_loss_ratio_reasonableness.sql**
  - Validates Loss Ratio is between 0% and 200%
  - Uses stratified sampling by LOB_CODE (10k per LOB)
  - Severity: WARN

- **test_premium_transaction_count.sql**
  - Validates active policies have at least one premium transaction
  - Samples 5k active policies
  - Severity: WARN

### Value Ranges & Data Quality
- **test_value_ranges_sampled.sql**
  - Consolidated test for all value range validations
  - Validates amounts >= 0, rates between 0-1, etc.
  - Uses stratified sampling (20k-50k rows per table)
  - Severity: WARN

- **test_not_null_critical_fields.sql**
  - Efficient NOT NULL validation using APPROX_COUNT_DISTINCT
  - Validates all critical fields across all models
  - Severity: ERROR

## Running Tests

```bash
# Run all tests (schema + singular)
dbt test

# Run only singular tests
dbt test --select test_type:singular

# Run only ERROR severity tests
dbt test --select test_severity:error

# Run tests for specific marts
dbt test --select marts

# Run specific test file
dbt test --select test_name:test_agent_net_revenue_calculation
```

## Performance Notes

All tests are optimized for performance:
- **No test scans more than 1 million rows**
- Uses Snowflake-specific optimizations (HLL, SAMPLE BERNOULLI, QUALIFY)
- Probabilistic approaches provide 95%+ confidence with <2% error margin
- Estimated runtime: <10 minutes for full suite on large datasets

## Dependencies

Requires `dbt-utils` package (defined in `packages.yml`):
```bash
dbt deps
```

## Documentation

See `tests_description.md` in the project root for comprehensive coverage details.
