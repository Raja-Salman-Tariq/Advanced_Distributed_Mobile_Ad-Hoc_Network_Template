# Quick Start Guide - dbt Test Suite

## Prerequisites
```bash
# Ensure dbt is installed and configured
dbt --version

# Install required packages
dbt deps
```

## Run All Tests (3-5 minutes)
```bash
dbt test
```

## Run Tests by Priority

### 1. Critical Tests Only (ERROR severity - must pass)
```bash
dbt test --select config.severity:error
```
**What it checks:**
- Primary key uniqueness (duplicates block deployment)
- Critical NOT NULL fields
- Core foreign key relationships
- Current exposure logic (policy versioning)

### 2. Warning Tests (WARN severity - investigate issues)
```bash
dbt test --select config.severity:warn
```
**What it checks:**
- Business logic calculations
- Date sequence validations
- Value range checks
- Code consistency
- Cross-model metrics

## Run Tests by Category

### Primary Key & Uniqueness Tests
```bash
dbt test --select test_name:test_primary_key_uniqueness_efficient
```

### NOT NULL Tests
```bash
dbt test --select test_name:test_not_null_critical_fields
```

### Referential Integrity Tests
```bash
dbt test --select test_name:test_referential_integrity_core
dbt test --select test_name:test_referential_integrity_claim_payments
```

### Business Logic Tests
```bash
dbt test --select test_name:test_fct_claims_incurred_calculation
dbt test --select test_name:test_fct_policy_premiums_agent_revenue
dbt test --select test_name:test_dim_policies_current_exposure
dbt test --select test_name:test_fct_claims_date_sequence
dbt test --select test_name:test_fct_claims_closed_date
```

### Value Range Tests
```bash
dbt test --select test_name:test_value_ranges_sampled
```

### Code Consistency Tests
```bash
dbt test --select test_name:test_code_consistency_lob
dbt test --select test_name:test_code_consistency_state
dbt test --select test_name:test_code_consistency_cause
```

### Cross-Model Tests
```bash
dbt test --select test_name:test_loss_ratio_reasonableness
dbt test --select test_name:test_premium_transaction_count
```

## Run Tests for Specific Models

```bash
# Test just the claims fact table
dbt test --select fct_claims

# Test all policy-related models
dbt test --select dim_policies fct_policy_premiums

# Test all marts
dbt test --select marts
```

## Interpreting Results

### ✅ Success
```
PASS test_primary_key_uniqueness_efficient
```
No action needed - data quality check passed

### ❌ ERROR Failure
```
FAIL 1 test_primary_key_uniqueness_efficient
```
**Action Required:**
- Fix the data quality issue immediately
- Do not deploy to production
- Review the failed records (see below)

### ⚠️ WARN Failure
```
WARN test_loss_ratio_reasonableness
```
**Action Recommended:**
- Investigate the issue
- Document the finding
- Track trends over time
- Deployment can proceed with caution

## Viewing Failed Test Details

When a test fails, dbt stores the failed records:

```bash
# View the specific failed records
dbt test --store-failures

# Then query the failure table in your warehouse:
# SELECT * FROM <schema>.<test_name>
```

Example for Snowflake:
```sql
-- View primary key duplicates
SELECT * FROM EKAI.demoModel_18.test_primary_key_uniqueness_efficient;

-- View invalid loss ratios
SELECT * FROM EKAI.demoModel_18.test_loss_ratio_reasonableness;
```

## Debugging Test Failures

### 1. Check Test SQL
Each test is a SQL file - you can run it directly:
```bash
# Compile the test to see the SQL
dbt compile --select test_name:test_primary_key_uniqueness_efficient

# View the compiled SQL
cat target/compiled/sentinel_insurance/tests/marts/test_primary_key_uniqueness_efficient.sql
```

### 2. Run Test SQL Manually
Copy the compiled SQL and run it in your SQL editor to investigate

### 3. Sample Failed Records
Tests return only failed records, so query results show exactly what's wrong

## Performance Tips

### If Tests Are Slow
1. Check sampling parameters in test files
2. Adjust `sample_size` parameters (default: 1M rows)
3. Consider running critical tests only in CI/CD

### Parallel Execution
```bash
# Increase thread count for faster execution
dbt test --threads 8
```

### Test Specific Models Only
```bash
# Test only recently changed models
dbt test --select state:modified+

# Test models and their children
dbt test --select fct_claims+
```

## CI/CD Integration

### Minimal CI/CD Pipeline
```yaml
# .github/workflows/dbt_tests.yml
- name: Run Critical Tests
  run: dbt test --select config.severity:error
  
- name: Run Warning Tests  
  run: dbt test --select config.severity:warn
  continue-on-error: true  # Don't block on warnings
```

### Full Test Suite
```yaml
- name: Run All Tests
  run: dbt test --store-failures
  
- name: Upload Test Results
  if: failure()
  run: |
    # Export failed test details
    # Send to monitoring system
```

## Monitoring & Alerting

Track test pass rates over time:
```sql
-- Query dbt run results
SELECT 
    test_name,
    status,
    count(*) as failure_count,
    execution_time
FROM dbt_test_results
WHERE run_date >= CURRENT_DATE - 30
GROUP BY 1, 2, 4
ORDER BY failure_count DESC;
```

## Common Issues & Solutions

### Issue: "Relation does not exist"
**Solution:** Run `dbt run` before `dbt test` to materialize models

### Issue: "Test taking too long"
**Solution:** Adjust sampling in test files (reduce LIMIT or SAMPLE size)

### Issue: "Too many WARN failures"
**Solution:** Review data quality at source, update validation rules if needed

### Issue: "HLL/APPROX functions not found"
**Solution:** Ensure you're connected to Snowflake (these are Snowflake-specific)

## Getting Help

1. **Test Documentation:** See `/tests_description.md` for detailed test logic
2. **Test Summary:** See `/TEST_SUITE_SUMMARY.md` for coverage overview
3. **Validation Rules:** See original validation rules document
4. **BRD Reference:** See Business Requirements Document

## Daily Workflow

```bash
# 1. Pull latest code
git pull

# 2. Install/update dependencies
dbt deps

# 3. Build models
dbt run

# 4. Run critical tests
dbt test --select config.severity:error

# 5. If critical tests pass, run all tests
dbt test

# 6. Review any warnings
# (Check test output for WARN failures)

# 7. Commit changes
git add .
git commit -m "Updated models - all tests passing"
git push
```

## Quick Reference

| Command | Purpose | Time |
|---------|---------|------|
| `dbt test` | Run all tests | 3-5 min |
| `dbt test --select config.severity:error` | Critical tests only | ~2 min |
| `dbt test --select test_type:singular` | Custom tests only | 2-3 min |
| `dbt test --select fct_claims` | One model | ~30 sec |
| `dbt test --store-failures` | Store failed records | 3-5 min |

---

**Questions?** Review `/tests_description.md` for comprehensive documentation.
