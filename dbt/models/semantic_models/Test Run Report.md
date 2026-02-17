# dbt Test Run Report

**Generated:** 2026-02-17 10:26:15

---

## Executive Summary

- **Total Tests:** 31
- **Passed:** 31 ✅
- **Failed:** 0 ❌
- **Success Rate:** 100.0%

## Test Run Metadata

- **dbt_schema_version:** https://schemas.getdbt.com/dbt/run-results/v6.json
- **dbt_version:** 1.9.10
- **generated_at:** 2026-02-17T10:16:32.908376Z
- **invocation_id:** 55d3152d-adbf-45da-97b4-99bf7a40d0a7
- **env:** {}

## Detailed Test Results

### DIM_AGENCIES Tests (1 total)

**✅ model.sentinel_insurance.dim_agencies**
- Status: `success`
- Execution Time: 0.04s

### DIM_AGENTS Tests (1 total)

**✅ model.sentinel_insurance.dim_agents**
- Status: `success`
- Execution Time: 0.04s

### DIM_CAUSE_OF_LOSS Tests (1 total)

**✅ model.sentinel_insurance.dim_cause_of_loss**
- Status: `success`
- Execution Time: 0.02s

### DIM_COVERAGE_CODES Tests (1 total)

**✅ model.sentinel_insurance.dim_coverage_codes**
- Status: `success`
- Execution Time: 0.03s

### DIM_LINE_OF_BUSINESS Tests (1 total)

**✅ model.sentinel_insurance.dim_line_of_business**
- Status: `success`
- Execution Time: 0.04s

### DIM_POLICIES Tests (1 total)

**✅ model.sentinel_insurance.dim_policies**
- Status: `success`
- Execution Time: 0.03s

### DIM_STATES Tests (1 total)

**✅ model.sentinel_insurance.dim_states**
- Status: `success`
- Execution Time: 0.04s

### FCT_CLAIM_PAYMENTS Tests (1 total)

**✅ model.sentinel_insurance.fct_claim_payments**
- Status: `success`
- Execution Time: 0.06s

### FCT_CLAIMS Tests (1 total)

**✅ model.sentinel_insurance.fct_claims**
- Status: `success`
- Execution Time: 0.03s

### FCT_POLICY_PREMIUMS Tests (1 total)

**✅ model.sentinel_insurance.fct_policy_premiums**
- Status: `success`
- Execution Time: 0.02s

### STG_AGENCIES Tests (1 total)

**✅ model.sentinel_insurance.stg_agencies**
- Status: `success`
- Execution Time: 0.02s

### STG_AGENTS Tests (1 total)

**✅ model.sentinel_insurance.stg_agents**
- Status: `success`
- Execution Time: 0.14s

### STG_CLAIM_PAYMENTS Tests (1 total)

**✅ model.sentinel_insurance.stg_claim_payments**
- Status: `success`
- Execution Time: 0.03s

### STG_CLAIMS Tests (1 total)

**✅ model.sentinel_insurance.stg_claims**
- Status: `success`
- Execution Time: 0.05s

### STG_PARTIES Tests (1 total)

**✅ model.sentinel_insurance.stg_parties**
- Status: `success`
- Execution Time: 0.04s

### STG_POLICIES Tests (1 total)

**✅ model.sentinel_insurance.stg_policies**
- Status: `success`
- Execution Time: 0.03s

### STG_POLICY_COVERAGES Tests (1 total)

**✅ model.sentinel_insurance.stg_policy_coverages**
- Status: `success`
- Execution Time: 0.04s

### STG_POLICY_PREMIUMS Tests (1 total)

**✅ model.sentinel_insurance.stg_policy_premiums**
- Status: `success`
- Execution Time: 0.03s

### STG_REF_CAUSE_OF_LOSS Tests (1 total)

**✅ model.sentinel_insurance.stg_ref_cause_of_loss**
- Status: `success`
- Execution Time: 0.06s

### STG_REF_COVERAGE_CODES Tests (1 total)

**✅ model.sentinel_insurance.stg_ref_coverage_codes**
- Status: `success`
- Execution Time: 0.05s

### STG_REF_LINE_OF_BUSINESS Tests (1 total)

**✅ model.sentinel_insurance.stg_ref_line_of_business**
- Status: `success`
- Execution Time: 0.02s

### STG_REF_STATES Tests (1 total)

**✅ model.sentinel_insurance.stg_ref_states**
- Status: `success`
- Execution Time: 0.02s

### TEST_AGENT_NET_REVENUE_CALCULATION Tests (1 total)

**✅ test.sentinel_insurance.test_agent_net_revenue_calculation**
- Status: `success`
- Execution Time: 0.02s

### TEST_CODE_CONSISTENCY_CAUSE Tests (1 total)

**✅ test.sentinel_insurance.test_code_consistency_cause**
- Status: `success`
- Execution Time: 0.05s

### TEST_CODE_CONSISTENCY_LOB Tests (1 total)

**✅ test.sentinel_insurance.test_code_consistency_lob**
- Status: `success`
- Execution Time: 0.02s

### TEST_CODE_CONSISTENCY_STATE Tests (1 total)

**✅ test.sentinel_insurance.test_code_consistency_state**
- Status: `success`
- Execution Time: 0.01s

### TEST_LOSS_RATIO_REASONABLENESS Tests (1 total)

**✅ test.sentinel_insurance.test_loss_ratio_reasonableness**
- Status: `success`
- Execution Time: 0.04s

### TEST_NOT_NULL_CRITICAL_FIELDS Tests (1 total)

**✅ test.sentinel_insurance.test_not_null_critical_fields**
- Status: `success`
- Execution Time: 0.06s

### TEST_PREMIUM_TRANSACTION_COUNT Tests (1 total)

**✅ test.sentinel_insurance.test_premium_transaction_count**
- Status: `success`
- Execution Time: 0.03s

### TEST_PRIMARY_KEY_UNIQUENESS_EFFICIENT Tests (1 total)

**✅ test.sentinel_insurance.test_primary_key_uniqueness_efficient**
- Status: `success`
- Execution Time: 0.04s

### TEST_VALUE_RANGES_SAMPLED Tests (1 total)

**✅ test.sentinel_insurance.test_value_ranges_sampled**
- Status: `success`
- Execution Time: 0.03s

## Complete Test List

1. ✅ `model.sentinel_insurance.stg_agencies` - success
2. ✅ `model.sentinel_insurance.stg_claim_payments` - success
3. ✅ `model.sentinel_insurance.stg_parties` - success
4. ✅ `model.sentinel_insurance.stg_claims` - success
5. ✅ `model.sentinel_insurance.stg_policies` - success
6. ✅ `model.sentinel_insurance.stg_policy_premiums` - success
7. ✅ `model.sentinel_insurance.stg_policy_coverages` - success
8. ✅ `model.sentinel_insurance.stg_agents` - success
9. ✅ `model.sentinel_insurance.stg_ref_cause_of_loss` - success
10. ✅ `model.sentinel_insurance.stg_ref_coverage_codes` - success
11. ✅ `model.sentinel_insurance.stg_ref_line_of_business` - success
12. ✅ `model.sentinel_insurance.stg_ref_states` - success
13. ✅ `model.sentinel_insurance.dim_agencies` - success
14. ✅ `model.sentinel_insurance.dim_policies` - success
15. ✅ `model.sentinel_insurance.fct_claims` - success
16. ✅ `model.sentinel_insurance.fct_claim_payments` - success
17. ✅ `model.sentinel_insurance.dim_agents` - success
18. ✅ `model.sentinel_insurance.fct_policy_premiums` - success
19. ✅ `model.sentinel_insurance.dim_cause_of_loss` - success
20. ✅ `model.sentinel_insurance.dim_line_of_business` - success
21. ✅ `model.sentinel_insurance.dim_coverage_codes` - success
22. ✅ `model.sentinel_insurance.dim_states` - success
23. ✅ `test.sentinel_insurance.test_agent_net_revenue_calculation` - success
24. ✅ `test.sentinel_insurance.test_premium_transaction_count` - success
25. ✅ `test.sentinel_insurance.test_loss_ratio_reasonableness` - success
26. ✅ `test.sentinel_insurance.test_not_null_critical_fields` - success
27. ✅ `test.sentinel_insurance.test_primary_key_uniqueness_efficient` - success
28. ✅ `test.sentinel_insurance.test_code_consistency_cause` - success
29. ✅ `test.sentinel_insurance.test_code_consistency_lob` - success
30. ✅ `test.sentinel_insurance.test_value_ranges_sampled` - success
31. ✅ `test.sentinel_insurance.test_code_consistency_state` - success

---

*Report generated by Claude Code from dbt run_results.json*