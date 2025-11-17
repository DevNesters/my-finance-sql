# Notebooks

This directory contains Jupyter notebooks for analyzing and visualizing personal finance data.

## Files

### queries.ipynb

A comprehensive notebook for personal finance data analysis and visualization.

**What it does:**
- Sets up a PostgreSQL database with sample financial data
- Connects to the database using configurable credentials
- Provides a framework for running SQL queries and creating visualizations
- Includes cleanup functionality to remove test data

**Notebook Structure:**

1. **Setup Database** - Runs the setup script to create database, tables, and insert sample data
2. **Database Configuration** - Define connection parameters (database name, user, password, host, port)
3. **Connect to Database** - Establishes connection to PostgreSQL using psycopg2
4. **Close Database Connection** - Properly closes the connection to free resources
5. **Cleanup Database** - Drops the database and removes all data (run only when finished)

## Prerequisites

Before running the notebooks, ensure you have:

1. **PostgreSQL installed and running**
   ```bash
   brew install postgresql
   brew services start postgresql
   ```

2. **Required Python packages**
   ```bash
   pip install pandas plotly psycopg2-binary jupyter
   ```

3. **Database user created**
   ```bash
   createuser -P finance_user
   # Enter password: her_finance_password
   ```

4. **Proper database configuration**
   - Check `config/database.yml` for database settings
   - Update notebook cell 6 if your credentials differ

## Usage

### Running the Notebook

1. Start Jupyter:
   ```bash
   jupyter notebook
   ```

2. Open `queries.ipynb`

3. Run cells in order:
   - Cell 1: Title and description
   - Cell 2-3: Setup database
   - Cell 4-5: Configure connection
   - Cell 6-7: Connect to database
   - Add your query/analysis cells here
   - Cell 8-9: Close connection
   - Cell 10-11: Cleanup (optional)

### Adding Custom Queries

To add your own queries and visualizations, insert new cells between the "Connect" and "Close" sections:

```python
# Example query
query = """
SELECT 
    p.name,
    SUM(it.amount) as total_income
FROM person p
JOIN income_transactions it ON p.id = it.person_id
GROUP BY p.name;
"""

df = pd.read_sql_query(query, conn)
print(df)

# Visualization with Plotly
import plotly.express as px
fig = px.bar(df, x='name', y='total_income', title='Total Income by Person')
fig.show()
```

## Database Schema

The setup script creates the following tables:

- **person** - User profiles (id, name, email, created_at)
- **income_categories** - Income category types (id, name, description)
- **income_transactions** - Income records (id, person_id, category_id, amount, transaction_date, description, created_at)
- **expenses_categories** - Expense category types (id, name, description)
- **expenses_transactions** - Expense records (id, person_id, category_id, amount, transaction_date, description, created_at)

## Troubleshooting

### "Database is being accessed by other users"

If cleanup fails with this error:
```bash
# Check active connections
psql -U finance_user -d her_finance_db -c "SELECT pid, usename, application_name FROM pg_stat_activity WHERE datname = 'her_finance_db';"

# Close the notebook connection first (run cell 9)
# Or terminate the connection manually:
psql -U finance_user -d her_finance_db -c "SELECT pg_terminate_backend(PID);"
```

### "NameError: name 'DB_NAME' is not defined"

Make sure you've run cell 6 (Database Configuration) before running cell 7 (Connect to Database).

### Connection errors

Verify PostgreSQL is running:
```bash
brew services list | grep postgresql
```

Check credentials match your `config/database.yml` file.

## Best Practices

1. **Always run cells in order** - Variables and connections depend on previous cells
2. **Close connections when done** - Run cell 9 to free up database resources
3. **Use cleanup sparingly** - Only run the cleanup script when you're completely finished
4. **Save your work** - Save the notebook frequently (Cmd+S or Ctrl+S)
5. **Restart kernel if needed** - If variables get messy: Kernel → Restart & Clear Output

## Related Files

- `../config/database.yml` - Database configuration
- `../scripts/setup.sh` - Database setup script
- `../scripts/cleanup.sh` - Database cleanup script
- `../sql/schema.sql` - Database schema definition
- `../sql/sample_data.sql` - Sample data for testing
