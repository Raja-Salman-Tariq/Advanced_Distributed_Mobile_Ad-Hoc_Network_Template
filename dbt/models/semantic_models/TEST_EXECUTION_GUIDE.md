# Test Execution Guide - Sentinel Insurance Analytics

## Quick Start

### 1. Install Dependencies
```bash
dbt deps
```

### 2. Run All Tests
```bash
dbt test
```

## Test Execution Strategies

### By Severity

```bash
# Run only ERROR severity tests (blocks deployment)
dbt test --select test_severity:error

# Run only WARN severity tests (monitoring)
dbt test --select test_severity:warn
```

### By Test Type

```bash
# Run only schema tests (defined in _marts_tests.yml)
dbt test --select test_type:schema

# Run only singular tests (custom SQL in tests/ directory)
dbt test --select test_type:singular
```

### By Model

```bash
# Test specific model
dbt test --select fct_claims
dbt test --select dim_policies

# Test all fact tables
dbt test --select fct_*

# Test all dimension tables
dbt test --select dim_*

# Test all marts
dbt test --select marts
```

### By Specific Test

```bash
# Run specific singular test
dbt test --select test_name:test_agent_net_revenue_calculation

# Run multiple specific tests
dbt test --select test_name:test_loss_ratio_reasonableness test_name:test_premium_transaction_count
```

## CI/CD Pipeline Recommendations

### Stage 1: Critical Validations (Fail Fast)
```bash
# Run ERROR severity tests only
dbt test --select test_severity:error
```
**Purpose**: Block deployment if critical data quality issues exist
**Runtime**: ~2-3 minutes

### Stage 2: Business Logic & Monitoring (Optional)
```bash
# Run WARN severity tests and store failures
dbt test --select test_severity:warn --store-failures
```
**Purpose**: Monitor data quality trends, log issues for investigation
**Runtime**: ~5-7 minutes

### Full Test Suite
```bash
# Run all tests
dbt test --store-failures
```
**Runtime**: ~8-10 minutes

## Test Results Interpretation

### Successful Test
```
PASS test_agent_net_revenue_calculation.......................... [PASS in 2.34s]
```
**Action**: None required

### Failed ERROR Test
```
FAIL 1 fct_claims_unique_claim_id................................. [FAIL 1 in 1.23s]
```
**Action**:
1. Investigate duplicate CLAIM_ID values
2. Fix data quality issue in source or staging
3. Re-run test before deployment

### Failed WARN Test
```
WARN 15 test_code_consistency_lob.................................. [WARN 15 in 3.45s]
```
**Action**:
1. Review orphaned LOB codes
2. Log issue for data governance team
3. Deployment can proceed (not blocking)

## Viewing Test Results

### Failed Test Details
```bash
# View failed test results (if --store-failures was used)
select * from sentinel_insurance.dbt_test__audit.fct_claims_unique_claim_id;
```

### Test Run History
```bash
# View test run history in dbt artifacts
cat target/run_results.json
```

## Performance Monitoring

### Check Test Execution Time
```bash
dbt test --profiles-dir . | grep "Done. PASS"
```

### Individual Test Performance
Monitor these tests - they should complete in:
- `test_primary_key_uniqueness_efficient`: <3 seconds
- `test_agent_net_revenue_calculation`: <5 seconds
- `test_loss_ratio_reasonableness`: <10 seconds
- `test_value_ranges_sampled`: <8 seconds

**If slower**: Adjust sampling rates in test SQL files

## Troubleshooting

### Test Timeout
**Issue**: Test runs longer than 5 minutes
**Solution**:
1. Review sampling rates in singular tests
2. Reduce `SAMPLE BERNOULLI` row counts
3. Check Snowflake warehouse size

### False Positives
**Issue**: Test fails but data is correct
**Solution**:
1. Check WHERE clause conditions
2. Verify NULL handling with COALESCE
3. Review tolerance thresholds (e.g., 0.01 for calculations)

### dbt_utils Not Found
**Issue**: `dbt_utils` functions not recognized
**Solution**:
```bash
dbt deps
```

## Sampling Calibration

Current sampling rates assume:
- `fct_claims`: 1M+ rows → Sample 50k-100k
- `fct_policy_premiums`: 500k+ rows → Sample 50k
- `dim_policies`: 100k+ rows → Sample 20k-50k

### Adjust Sampling
If data volume changes significantly:

1. Edit test file (e.g., `test_value_ranges_sampled.sql`)
2. Update `SAMPLE BERNOULLI (N ROWS)` parameter
3. Test new sampling rate
4. Document change in test file comment

**Example**:
```sql
-- Change from 50k to 100k rows
FROM {{ ref('fct_claims') }}
SAMPLE BERNOULLI (100000 ROWS)  -- Increased for larger dataset
```

## Test Coverage Summary

| Category | Tests | Severity | Runtime |
|----------|-------|----------|---------|
| Primary Key Uniqueness | 10 | ERROR | ~2s |
| NOT NULL Validations | 13 | ERROR | ~3s |
| Referential Integrity | 4 | ERROR/WARN | ~2s |
| Business Logic | 5 | WARN | ~8s |
| Value Ranges | 10 | WARN | ~8s |
| Code Consistency | 3 | WARN | ~6s |
| Cross-Model | 2 | WARN | ~12s |
| **TOTAL** | **47** | - | **~10min** |

## Best Practices

1. **Run ERROR tests first**: `dbt test --select test_severity:error`
2. **Use --store-failures in CI/CD**: Enables result querying
3. **Monitor WARN trends**: Increasing failures indicate data quality decay
4. **Review test performance quarterly**: Adjust sampling as data grows
5. **Document test failures**: Track patterns for root cause analysis

## Support

For questions about:
- **Test logic**: See `tests_description.md`
- **Validation rules**: See validation rules document
- **Business requirements**: See BRD document
- **Test files**: See `tests/README.md`
