# Warehouse Design and dbt Pipelines

## Environment Setup

```bash
docker --version
docker-compose --version
```

Start PostgreSQL:

```bash
docker-compose up -d
docker exec -it <container_name> psql -U dbtuser -d retail_db
```

Install dbt (Windows):

```bash
python -m venv dbt-env
dbt-env\Scripts\activate
pip install dbt-postgres
dbt --version
```

Initialize dbt:

```bash
dbt init retail_project
cd retail_project
dbt debug
```

Load raw data:

```bash
docker exec -it <container_name> psql -U dbtuser -d retail_db -f /path/to/schema.sql
```

## Project Structure

- `docker-compose.yml`
- `schema.sql`
- `retail_project/dbt_project.yml`
- `retail_project/models/sources.yml`
- `retail_project/models/staging/stg_orders.sql`
- `retail_project/models/staging/stg_customers.sql`
- `retail_project/models/intermediate/int_orders_joined.sql`
- `retail_project/models/mart/mart_fact_sales.sql`
- `retail_project/models/staging/schema.yml`
- `retail_project/models/mart/schema.yml`

## Run dbt

```bash
cd retail_project
dbt run
dbt test
dbt docs generate
dbt docs serve
```

## Required Screenshots

Save screenshots in `screenshots/`:

- `erd.png`
- `scd_type2_select.png`
- `dbt_run_success.png`
- `dbt_test_success.png`
- `dbt_lineage_graph.png`

## Reflection Notes

- Star schema grain: one row in fact table equals one order line.
- SCD Type 2: old record expires, new record becomes current.
- Lineage should be: `raw_orders -> stg_orders/stg_customers -> int_orders_joined -> mart_fact_sales`.
