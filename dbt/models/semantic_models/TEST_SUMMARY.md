# Test Summary - Quick Reference

## Total Test Coverage
- **Schema Tests (YAML):** 28 column-level + 3 model-level = 31 tests
- **Singular Tests (SQL):** 9 custom tests
- **Total:** 40 comprehensive tests

---

## Test Execution Commands

### Run All Tests
```bash
dbt test
```

### Run Tests by Model
```bash
dbt test --select dim_agency
dbt test --select dim_agent
dbt test --select bridge_agency_hierarchy
```

### Run Tests by Type
```bash
dbt test --select test_type:singular    # Only custom SQL tests
dbt test --select test_type:schema      # Only YAML-defined tests
```

### Run Tests by Severity
```bash
dbt test --select test_severity:error   # Critical tests only
dbt test --select test_severity:warn    # Warning tests only
```

---

## Test Files Location

### Schema Tests
- **Location:** `models/marts/_marts.yml`
- **Coverage:** Column constraints, data types, relationships, business rules

### Singular Tests
- **Location:** `tests/` directory
- **Files:**
  - `test_dim_agency_primary_key_uniqueness.sql`
  - `test_dim_agency_referential_integrity_agent.sql`
  - `test_dim_agency_referential_integrity_hierarchy.sql`
  - `test_dim_agent_primary_key_uniqueness.sql`
  - `test_dim_agent_phone_uniqueness.sql`
  - `test_dim_agent_termination_date_logic.sql`
  - `test_bridge_agency_hierarchy_primary_key_uniqueness.sql`
  - `test_cross_table_orphaned_agents.sql`
  - `test_cross_table_agent_count_per_agency.sql`

---

## Validation Rules Coverage Matrix

| Model | Rule Category | Critical | High | Medium | Low |
|-------|--------------|----------|------|--------|-----|
| **dim_agency** | Primary Keys | ✅ | - | - | - |
| | Required Fields | ✅ | - | - | - |
| | Referential Integrity | - | ✅ | - | - |
| | Data Type Validation | - | - | ✅ | - |
| | Boolean Flags | - | ✅ | - | - |
| **dim_agent** | Primary Keys | ✅ | - | - | - |
| | Required Fields | ✅ | - | - | - |
| | Referential Integrity | ✅ | - | - | - |
| | Email Uniqueness | - | ✅ | - | - |
| | Phone Uniqueness | - | - | ✅ | - |
| | Commission Range | - | - | ✅ | - |
| | Temporal Consistency | - | ✅ | - | - |
| | Active Status Logic | - | - | ✅ | - |
| **bridge_agency_hierarchy** | Primary Keys | ✅ | - | - | - |
| | Required Fields | ✅ | - | - | - |
| | Referential Integrity | ✅ | - | - | - |
| | Hierarchy Level Range | - | - | ✅ | - |
| | Self-Referencing | - | ✅ | - | - |
| | Effective Date | - | - | ✅ | - |
| **Cross-Table** | Orphaned Records | ✅ | - | - | - |
| | Agent Count Outliers | - | - | - | ✅ |

---

## Key Validation Rules

### Critical (Fails Build)
- ✅ All primary keys are unique and not null
- ✅ All required fields are populated
- ✅ All foreign keys reference valid records
- ✅ No orphaned agent records
- ✅ No self-referencing hierarchies

### High Priority (Warnings)
- ✅ Email addresses are unique
- ✅ Boolean flags have valid values
- ✅ Termination dates are after hire dates
- ✅ Active agencies maintain relationships

### Medium Priority (Warnings)
- ✅ Commission rates between 0-1
- ✅ Phone numbers are unique
- ✅ Hierarchy levels 1-3
- ✅ Effective dates not in future
- ✅ Terminated agents marked inactive

### Low Priority (Informational)
- ✅ No agency has >1000 agents

---

## Documentation

For detailed information about test implementation and validation rule mapping, see:
- **[tests_description.md](./tests_description.md)** - Comprehensive test documentation

---

## Test Development Guidelines

### When to Use Schema Tests
- Column-level validations (not null, unique)
- Data type constraints (accepted values, ranges)
- Simple relationships (foreign keys)
- Standard dbt or dbt_utils tests

### When to Use Singular Tests
- Complex business logic
- Cross-table validations
- Multi-condition rules
- Custom severity handling
- Informational checks

---

## Maintenance Notes

- Schema tests are defined alongside model documentation in `_marts.yml`
- Singular tests are version-controlled in `tests/` directory
- All tests align with BRD requirements and validation framework
- Tests are categorized by severity (error vs warn)
- Model-level WHERE clauses provide additional data quality enforcement

---

**Last Updated:** 2026-01-28
**dbt Version:** Compatible with dbt 1.x
**Required Packages:** dbt_utils
