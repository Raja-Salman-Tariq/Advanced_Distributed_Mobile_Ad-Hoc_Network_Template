# Sentinel Insurance - dbt Data Pipeline

## Overview
This dbt project implements a comprehensive data pipeline for Sentinel Insurance's agency management system. The pipeline transforms raw source data into analytics-ready dimensional models following the medallion architecture pattern.

## Project Structure

```
models/
├── sources.yml                          # Source table definitions
├── staging/                             # Bronze → Silver layer
│   ├── _staging.yml                     # Staging model documentation and tests
│   ├── stg_agency.sql                   # Standardized agency data
│   ├── stg_agency_hierarchy.sql         # Standardized hierarchy relationships
│   └── stg_agent.sql                    # Standardized agent data
├── intermediate/                        # Silver layer enrichment
│   ├── _intermediate.yml                # Intermediate model documentation
│   ├── int_agency_with_contact.sql      # Agency with formatted contact info
│   ├── int_agent_with_license.sql       # Agent with license validation
│   └── int_hierarchy_relationships.sql  # Resolved hierarchy relationships
└── marts/                               # Gold layer - Analytics
    ├── _marts.yml                       # Marts documentation and validation tests
    ├── dim_agency.sql                   # Agency dimension table
    ├── dim_agent.sql                    # Agent dimension table
    └── bridge_agency_hierarchy.sql      # Agency hierarchy bridge table
```

## Data Lineage

### Source Tables (Bronze Layer)
- **AGENCY**: Raw agency data with licensing and contact information
- **AGENCY_HIERARCHY**: Parent-child relationships between agencies
- **AGENT**: Individual agent records with employment and licensing details

### Staging Layer (Silver Layer)
- **stg_agency**: Standardized agency data with type casting and null handling
- **stg_agency_hierarchy**: Cleansed hierarchy data with date formatting
- **stg_agent**: Standardized agent data with date transformations

### Intermediate Layer (Silver Layer - Enriched)
- **int_agency_with_contact**: Enriched agency data with:
  - Formatted contact information (standardized email, phone)
  - Location standardization (uppercase state codes, city-state combinations)
  - Validated commission rates
  - Data quality flags

- **int_agent_with_license**: Agent data enriched with:
  - Full name concatenation
  - License status calculations (VALID, EXPIRING_SOON, EXPIRED)
  - Tenure calculations
  - Employment date validation

- **int_hierarchy_relationships**: Resolved hierarchies with:
  - Parent-child agency details
  - Hierarchy position classification
  - Self-referencing detection
  - Invalid level flagging

### Marts Layer (Gold Layer)
- **dim_agency**: Final agency dimension for analytics
- **dim_agent**: Final agent dimension with agency denormalization
- **bridge_agency_hierarchy**: Bridge table for many-to-many hierarchy relationships

## Key Features

### Data Quality & Validation
- **Primary Key Tests**: All dimension tables have unique and not null constraints
- **Referential Integrity**: Foreign key relationships validated across all layers
- **Business Rule Validation**:
  - Commission rates between 0-1
  - Hire date before termination date
  - No self-referencing hierarchies
  - Hierarchy levels within valid range (1-3)

### Business Metrics Support
The models support calculations for:
- Total Active Agencies/Agents
- Average Commission Rates and Splits
- Agents per Agency
- License Expiration Tracking
- Agent Retention Rate
- Regional Agency Distribution
- Hierarchy Level Analysis

### Snowflake Optimizations
- **Staging/Intermediate**: Materialized as VIEWS for flexibility and storage efficiency
- **Marts**: Materialized as TABLES for optimal query performance
- **Type Casting**: Explicit type conversions using Snowflake functions (TRY_TO_DATE, TRY_TO_TIMESTAMP)
- **String Functions**: Snowflake-specific regex and formatting

## Setup Instructions

### Prerequisites
- dbt Core 1.9+ installed
- dbt-snowflake adapter installed
- Access to Snowflake account with appropriate permissions

### Environment Variables
Set the following environment variables:
```bash
export SNOWFLAKE_ACCOUNT=<your_account>
export SNOWFLAKE_USER=<your_user>
export SNOWFLAKE_PASSWORD=<your_password>
export SNOWFLAKE_ROLE=<your_role>
export SNOWFLAKE_WAREHOUSE=<your_warehouse>
```

### Installation Steps

1. **Install dbt packages**:
```bash
dbt deps
```

2. **Validate project configuration**:
```bash
dbt parse
```

3. **Run the pipeline**:
```bash
# Full refresh
dbt run

# Run specific layer
dbt run --select staging
dbt run --select intermediate
dbt run --select marts
```

4. **Run tests**:
```bash
# All tests
dbt test

# Source tests only
dbt test --select source:*

# Marts tests only
dbt test --select marts
```

5. **Generate documentation**:
```bash
dbt docs generate
dbt docs serve
```

## Model Dependencies

```
AGENCY (source)
  └─> stg_agency
       └─> int_agency_with_contact
            └─> dim_agency

AGENCY_HIERARCHY (source)
  └─> stg_agency_hierarchy ─┐
                             ├─> int_hierarchy_relationships
       stg_agency ───────────┘         └─> bridge_agency_hierarchy

AGENT (source)
  └─> stg_agent
       └─> int_agent_with_license ─┐
                                    ├─> dim_agent
            stg_agency ─────────────┘
```

## Validation Rules Implemented

### dim_agency
- ✓ Unique agency_id and agency_code
- ✓ Required fields (name, license_number) not null
- ✓ Commission rate between 0-1
- ✓ Boolean is_active flag validation

### dim_agent
- ✓ Unique agent_code and email
- ✓ Unique phone numbers
- ✓ Valid agency_id references
- ✓ Commission split between 0-1
- ✓ Termination date after hire date
- ✓ All required fields populated

### bridge_agency_hierarchy
- ✓ Unique hierarchy_id
- ✓ Valid agency references
- ✓ No self-referencing relationships
- ✓ Hierarchy level in range 1-3
- ✓ Effective date not in future
- ✓ Required fields not null

## Performance Considerations

- **Views (Staging/Intermediate)**: Zero storage overhead, always fresh data
- **Tables (Marts)**: Faster query performance for analytics workloads
- **Incremental Strategy**: Can be added for large datasets using partitioning on created_date

## Best Practices Implemented

1. **Naming Conventions**:
   - `stg_` prefix for staging models
   - `int_` prefix for intermediate models
   - `dim_` prefix for dimension tables
   - `bridge_` prefix for bridge tables

2. **Column Naming**: Consistent snake_case throughout all layers

3. **Documentation**: Comprehensive descriptions at model and column level

4. **Testing Strategy**: Multi-layered approach from source to mart validation

5. **Modularity**: Clear separation of concerns across layers

## Troubleshooting

### Common Issues

**Issue**: `Env var required but not provided`
- **Solution**: Ensure all required environment variables are set

**Issue**: `Compilation Error: depends on a node named 'X' which was not found`
- **Solution**: Run `dbt clean` then `dbt parse`

**Issue**: `Database Error: insufficient privileges`
- **Solution**: Verify Snowflake role has appropriate permissions on database and schema

## Maintenance

### Adding New Models
1. Create SQL file in appropriate directory
2. Update corresponding `_<layer>.yml` with documentation
3. Add tests and column descriptions
4. Run `dbt parse` to validate
5. Execute `dbt run --select <model_name>+`

### Modifying Existing Models
1. Update SQL in model file
2. Update documentation in YAML if column changes
3. Run `dbt run --select <model_name>+` to rebuild downstream dependencies
4. Execute `dbt test --select <model_name>+` to validate

## Contact & Support
For questions or issues related to this dbt project, please contact the Data Engineering team.

---
**Generated with dbt Core 1.9.10 | Snowflake Adapter 1.9.4**
