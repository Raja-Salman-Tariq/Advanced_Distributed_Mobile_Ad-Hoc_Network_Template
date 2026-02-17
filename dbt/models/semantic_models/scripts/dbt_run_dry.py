import os
import snowflake.connector
from pathlib import Path

COMPILED_DIR = Path("target/compiled")

def get_sql_files():
    base = COMPILED_DIR
    return list(base.rglob("*.sql"))

def main():
    conn = snowflake.connector.connect(
        # reuse env vars or profiles.yml creds
        user=INSERT_VALUES,
        password=INSERT_VALUES,
        account=INSERT_VALUES,
        warehouse=INSERT_VALUES,
        database=INSERT_VALUES,
        schema=INSERT_VALUES,
    )

    cursor = conn.cursor()

    for file in get_sql_files():
        print(f"Dry running: {file}")

        sql = file.read_text()

        try:
            cursor.execute(f"EXPLAIN USING TEXT {sql}")
        except Exception as e:
            print(f"FAILED: {file}")
            print(e)
            raise

    cursor.close()
    conn.close()
    print("Dry run successful.")

if __name__ == "__main__":
    main()
