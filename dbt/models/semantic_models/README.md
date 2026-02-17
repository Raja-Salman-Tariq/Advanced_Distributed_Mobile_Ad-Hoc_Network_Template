# Sentinel Insurance Analytics - dbt Pipeline

## Overview
This dbt project implements a semantic layer for Sentinel Insurance analytics, supporting key business metrics including Loss Ratio analysis, Agent Net Revenue tracking, and Current Exposure reporting.

## Architecture

### Data Flow
```
BRONZE (Source) → STAGING (Cleansing) → MARTS (Business-Ready)
```

### Layer Strategy
- **2-Layer Architecture**: Staging → Marts (no intermediate layer needed)
- **Materialization**: All models are views for real-time freshness
- **Target Platform**: Snowflake

## Project Structure

```
/app/workspaces/18/
├── dbt_project.yml          # Project configuration
├── profiles.yml              # Snowflake connection profile
├── README.md                 # This file
│
└── models/
    ├── sources.yml           # Source definitions (BRONZE schema)
    │
    ├── staging/              # 12 staging models
    │   ├── _staging.yml      # Staging schema documentation
    │   ├── stg_claims.sql
    │   ├── stg_claim_payments.sql
    │   ├── stg_policies.sql
    │   ├── stg_policy_premiums.sql
    │   ├── stg_policy_coverages.sql
    │   ├── stg_agents.sql
    │   ├── stg_agencies.sql
    │   ├── stg_parties.sql
    │   ├── stg_ref_line_of_business.sql
    │   ├── stg_ref_states.sql
    │   ├── stg_ref_cause_of_loss.sql
    │   └── stg_ref_coverage_codes.sql
    │
    └── marts/                # 10 mart models (3 facts + 7 dimensions)
        ├── _marts.yml        # Marts schema documentation
        ├── fct_claims.sql
        ├── fct_claim_payments.sql
        ├── fct_policy_premiums.sql
        ├── dim_policies.sql
        ├── dim_agents.sql
        ├── dim_agencies.sql
        ├── dim_line_of_business.sql
        ├── dim_states.sql
        ├── dim_cause_of_loss.sql
        └── dim_coverage_codes.sql
```

## Key Features

### 1. Loss Ratio Analysis
- **fct_claims**: Contains TOTAL_INCURRED (numerator for Loss Ratio)
- **fct_policy_premiums**: Contains EARNED_PREMIUM (denominator for Loss Ratio)
- **Formula**: `(SUM(TOTAL_INCURRED) / NULLIF(SUM(EARNED_PREMIUM), 0)) * 100`

### 2. Agent Net Revenue Tracking
- **fct_policy_premiums**: Pre-calculates AGENT_NET_REVENUE
- **Calculation**: `COMMISSION_AMOUNT × COMMISSION_SPLIT`
- **dim_agents**: Contains commission split rates

### 3. Current Exposure Logic
- **dim_policies**: Only includes latest version per policy number
- **Implementation**: Window function to get MAX(POLICY_VERSION) per POLICY_NUMBER
- Supports Current Exposure KPIs for policy count and total premium at risk

### 4. Data Quality
- Date parsing with `TRY_TO_DATE()` for safe conversions
- NULL handling with defaults:
  - LOB_CODE → 'Unclassified'
  - STATE_CODE → 'Unclassified'
- Business logic validation for:
  - TOTAL_INCURRED = TOTAL_PAID + TOTAL_RESERVE
  - AGENT_NET_REVENUE calculation accuracy

## Schema Targeting

- **Source Database**: `SENTINEL_INSURANCE.BRONZE`
- **Staging Schema**: `SENTINEL_INSURANCE.STAGING`
- **Marts Schema**: `SENTINEL_INSURANCE.MARTS`

## Model Inventory

### Staging Layer (12 models)
1. stg_claims
2. stg_claim_payments
3. stg_policies
4. stg_policy_premiums
5. stg_policy_coverages
6. stg_agents
7. stg_agencies
8. stg_parties
9. stg_ref_line_of_business
10. stg_ref_states
11. stg_ref_cause_of_loss
12. stg_ref_coverage_codes

### Marts Layer (10 models)

#### Fact Tables (3)
1. **fct_claims** - Claims with financial metrics
2. **fct_claim_payments** - Payment transactions
3. **fct_policy_premiums** - Premium transactions with AGENT_NET_REVENUE

#### Dimension Tables (7)
1. **dim_policies** - Policies (Current Exposure logic)
2. **dim_agents** - Agents with commission splits
3. **dim_agencies** - Agencies
4. **dim_line_of_business** - Lines of Business
5. **dim_states** - Geographic states
6. **dim_cause_of_loss** - Loss causes
7. **dim_coverage_codes** - Coverage types

## Key Business Metrics Supported

### Primary KPIs
- **Loss Ratio**: `SUM(fct_claims.TOTAL_INCURRED) / NULLIF(SUM(fct_policy_premiums.EARNED_PREMIUM), 0) * 100`
- **Loss Ratio by LOB**: Loss ratio grouped by LOB_CODE
- **Agent Net Revenue**: `SUM(fct_policy_premiums.AGENT_NET_REVENUE)`
- **Current Exposure - Policy Count**: `COUNT(DISTINCT dim_policies.POLICY_ID)`
- **Current Exposure - Total Premium**: `SUM(dim_policies.ANNUAL_PREMIUM)`

### Supporting Metrics
- Total Incurred Losses
- Total Earned Premium
- Total Paid Claims
- Total Claim Reserves
- Average Claim Severity
- Claim Frequency
- Commission Ratio
- Active Policy Count by State
- Premium Volume by LOB

## Naming Conventions

- **Column Names**: UPPER_CASE (Snowflake standard)
- **Table Names**: lowercase with underscores (snake_case)
- **Staging Models**: Prefixed with `stg_`
- **Fact Tables**: Prefixed with `fct_`
- **Dimension Tables**: Prefixed with `dim_`

## Usage

### Running the Pipeline

```bash
# Parse and validate project
dbt parse --profiles-dir /app/workspaces/18

# Compile models (generate SQL)
dbt compile --profiles-dir /app/workspaces/18

# Run all models
dbt run --profiles-dir /app/workspaces/18

# Run specific layer
dbt run --select staging.* --profiles-dir /app/workspaces/18
dbt run --select marts.* --profiles-dir /app/workspaces/18

# Run specific model
dbt run --select fct_claims --profiles-dir /app/workspaces/18
```

### Running Tests
Tests are managed separately by the data quality agent.

## Configuration

### Environment Variables Required
Set these in your environment or Snowflake connection:
- `SNOWFLAKE_ACCOUNT`
- `SNOWFLAKE_USER`
- `SNOWFLAKE_PASSWORD`
- `SNOWFLAKE_ROLE` (default: TRANSFORMER)
- `SNOWFLAKE_WAREHOUSE` (default: TRANSFORMING)

### dbt Variables
Defined in `dbt_project.yml`:
- `default_lob_code`: 'Unclassified'
- `default_state_code`: 'Unclassified'

## Design Decisions

### Why No Intermediate Layer?
- Limited cross-source complexity
- Only 2 models join multiple staging tables (fct_policy_premiums, dim_policies)
- Business logic is simple enough for direct staging → marts transformation
- Follows KISS principle

### Why Views Instead of Tables?
- Real-time data freshness
- Minimal storage costs on Snowflake
- Leverage Snowflake's query optimization
- Simplified maintenance (no incremental logic)

### Why Flat Marts Directory?
- Per requirements: Single flat directory for all mart models
- One schema file (_marts.yml) for all marts documentation
- Simpler navigation and maintenance

## Source System

All source tables come from `SENTINEL_INSURANCE.BRONZE` schema:
- AGENCY
- AGENT
- CLAIM
- CLAIM_PAYMENT
- PARTY
- POLICY
- POLICY_COVERAGE
- POLICY_PREMIUM
- REF_CAUSE_OF_LOSS
- REF_COVERAGE_CODE
- REF_LINE_OF_BUSINESS
- REF_STATE

## Next Steps

1. Configure Snowflake connection credentials
2. Run `dbt compile` to validate SQL compilation
3. Run `dbt run` to materialize all models
4. Execute data quality tests (managed by separate agent)
5. Connect BI tools to marts schema for reporting

## Support

For questions or issues with this dbt pipeline, refer to:
- Business requirements defined in Business Glossary
- Technical specifications in Technical Glossary
- Metrics definitions in Metrics documentation
- Data quality rules in Validation documentation
