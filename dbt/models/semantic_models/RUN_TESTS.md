# dbt Test Execution Guide

## Quick Start

### Run All Tests
```bash
dbt test
```

This will execute all 40 tests (31 schema tests + 9 singular tests).

---

## Run Tests by Model

### Test dim_agency Only
```bash
dbt test --select dim_agency
```
**Coverage:**
- Primary key validation (agency_id)
- Required fields (agency_code, agency_name, license_number)
- Commission rate range (0-1)
- Active status boolean validation
- Plus 3 singular tests for referential integrity

### Test dim_agent Only
```bash
dbt test --select dim_agent
```
**Coverage:**
- Primary key validation (agent_code)
- Required fields (8 fields)
- Email and phone uniqueness
- Commission split range (0-1)
- Agency foreign key relationship
- Temporal consistency (hire/termination dates)
- Plus 3 singular tests

### Test bridge_agency_hierarchy Only
```bash
dbt test --select bridge_agency_hierarchy
```
**Coverage:**
- Primary key validation (hierarchy_id)
- Required fields (agency_id, hierarchy_level, effective_date)
- Referential integrity (agency_id, parent_agency_id)
- Hierarchy level range (1-3)
- Self-referencing prevention
- Effective date validation
- Plus 1 singular test

---

## Run Tests by Type

### Schema Tests Only (YAML-defined)
```bash
dbt test --select test_type:schema
```
Runs only the 31 tests defined in `models/marts/_marts.yml`

### Singular Tests Only (Custom SQL)
```bash
dbt test --select test_type:singular
```
Runs only the 9 custom SQL tests in the `tests/` directory

---

## Run Tests by Severity

### Critical Tests Only (Errors)
```bash
dbt test --select test_severity:error
```
Runs tests that will fail the build if they fail.

### Warning Tests Only
```bash
dbt test --select test_severity:warn
```
Runs tests that log warnings but don't fail the build.

---

## Run Specific Test Files

### Run a Single Singular Test
```bash
dbt test --select test_dim_agency_primary_key_uniqueness
dbt test --select test_cross_table_orphaned_agents
```

### Run Multiple Specific Tests
```bash
dbt test --select test_dim_agency_primary_key_uniqueness test_dim_agent_primary_key_uniqueness
```

---

## Advanced Test Selection

### Run Tests for a Specific Column
```bash
dbt test --select dim_agency,column:agency_id
dbt test --select dim_agent,column:email
```

### Run All Relationship Tests
```bash
dbt test --select test_type:relationships
```

### Run All Uniqueness Tests
```bash
dbt test --select test_type:unique
```

### Run All Not Null Tests
```bash
dbt test --select test_type:not_null
```

---

## Test and Build Together

### Build Models and Run Tests
```bash
dbt build
```
This will:
1. Build all models
2. Run all tests
3. Fail if any critical test fails

### Build and Test Specific Model
```bash
dbt build --select dim_agency
dbt build --select dim_agent
dbt build --select bridge_agency_hierarchy
```

---

## Debugging Failed Tests

### Run Tests in Debug Mode
```bash
dbt test --debug
```

### Store Test Results
```bash
dbt test --store-failures
```
Failed test results will be stored as tables in your warehouse for investigation.

### View Test Results
```bash
dbt test --store-failures
# Then query the test result tables in your warehouse
# Tables will be named like: <schema>_dbt_test__audit.<test_name>
```

---

## Interpreting Test Results

### Success Output
```
Completed successfully
Done. PASS=40 WARN=0 ERROR=0 SKIP=0 TOTAL=40
```

### Failure Output Examples

**Critical Failure (Build Fails):**
```
Failure in test not_null_dim_agency_agency_id (models/marts/_marts.yml)
  Got 5 results, configured to fail if != 0
```

**Warning (Build Continues):**
```
Warn in test test_cross_table_agent_count_per_agency (tests/test_cross_table_agent_count_per_agency.sql)
  Got 2 results, configured to warn if != 0
```

---

## Common Test Scenarios

### Pre-Deployment Validation
```bash
# Run all critical tests before deployment
dbt test --select test_severity:error
```

### Post-Deployment Smoke Test
```bash
# Build everything and run all tests
dbt build
```

### Daily Data Quality Check
```bash
# Run all tests and store failures for analysis
dbt test --store-failures
```

### Investigate Specific Model Issues
```bash
# Focus on one model and its tests
dbt build --select dim_agent
```

---

## Test Performance Tips

### Run Tests in Parallel
```bash
# Use multiple threads for faster execution
dbt test --threads 4
```

### Run Only Modified Model Tests
```bash
# Test only models that changed
dbt test --select state:modified
```

### Exclude Slow Tests
```bash
# Run all except specific tests
dbt test --exclude test_cross_table_agent_count_per_agency
```

---

## Continuous Integration (CI)

### CI Pipeline Example
```bash
#!/bin/bash
# ci_test_pipeline.sh

echo "Running dbt tests..."

# Step 1: Build models
dbt build --select state:modified --defer --state ./prod_manifest

# Step 2: Run critical tests
dbt test --select test_severity:error

# Step 3: Run all tests with failure storage
dbt test --store-failures

echo "Tests complete!"
```

---

## Test Maintenance

### List All Tests
```bash
dbt list --resource-type test
```

### Compile Tests (Without Running)
```bash
dbt compile --select test_type:singular
```

### Generate Documentation with Test Coverage
```bash
dbt docs generate
dbt docs serve
```

---

## Validation Rule Checklist

After running `dbt test`, verify these critical validations passed:

- [ ] All primary keys are unique and not null
- [ ] All required fields are populated
- [ ] All foreign key relationships are valid
- [ ] No orphaned agent records exist
- [ ] Commission rates/splits are between 0-1
- [ ] No agencies have >1000 agents
- [ ] Termination dates are after hire dates
- [ ] No self-referencing hierarchies
- [ ] Effective dates are not in the future
- [ ] Terminated agents are marked as inactive

---

## Troubleshooting

### Test Fails Due to Missing dbt_utils
```bash
dbt deps  # Install required packages
dbt test  # Re-run tests
```

### Test Timeout Issues
```bash
# Increase timeout in profiles.yml or run specific tests
dbt test --select dim_agency  # Test one model at a time
```

### Schema Test Not Found
```bash
# Ensure you've compiled the project
dbt compile
dbt test
```

---

## Documentation References

- **Comprehensive Test Documentation:** [tests_description.md](./tests_description.md)
- **Quick Reference Guide:** [TEST_SUMMARY.md](./TEST_SUMMARY.md)
- **dbt Testing Documentation:** https://docs.getdbt.com/docs/build/tests

---

**Last Updated:** 2026-01-28
