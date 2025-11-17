# Personal Finance Tracker

A PostgreSQL-based personal finance tracking and analysis system with data visualization capabilities using Python and Plotly.

## Overview

This project provides a complete solution for tracking and analyzing personal finances, including income and expenses across different categories. It includes database setup scripts, sample data, and Jupyter notebooks for interactive data analysis and visualization.

## Features

- 📊 **PostgreSQL Database** - Robust relational database for storing financial data
- 💰 **Income Tracking** - Track income by category (salary, bonuses, reimbursements, gifts)
- 💸 **Expense Tracking** - Monitor expenses across multiple categories (mortgage, utilities, groceries, etc.)
- 👥 **Multi-Person Support** - Track finances for multiple people
- 📈 **Data Visualization** - Interactive charts and graphs using Plotly
- 📓 **Jupyter Notebooks** - Interactive analysis environment
- 🔧 **Automated Scripts** - Easy setup and cleanup scripts

## Project Structure

```
personal-finance/
├── config/                 # Configuration files
│   ├── database.yml       # Database connection settings
│   └── README.md          # Config documentation
├── notebooks/             # Jupyter notebooks
│   ├── queries.ipynb      # Main analysis notebook
│   └── README.md          # Notebook documentation
├── scripts/               # Shell scripts
│   ├── setup.sh          # Database setup script
│   └── cleanup.sh        # Database cleanup script
├── sql/                   # SQL files
│   ├── schema.sql        # Database schema definition
│   └── sample_data.sql   # Sample data for testing
└── README.md             # This file
```

## Prerequisites

### Software Requirements

1. **PostgreSQL** (version 12 or higher)
   ```bash
   brew install postgresql
   brew services start postgresql
   ```

2. **Python** (version 3.8 or higher)
   ```bash
   python --version
   ```

3. **Python Packages**
   ```bash
   pip install pandas plotly psycopg2-binary jupyter pyyaml
   ```

4. **yq** (YAML processor - optional, for advanced config management)
   ```bash
   brew install yq
   ```

### Database User Setup

Create a PostgreSQL user for the application:

```bash
createuser -P finance_user
# Enter password: her_finance_password
```

## Quick Start

### 1. Clone or Download the Project

```bash
cd ~/Desktop
# If you already have the project, skip to step 2
```

### 2. Configure Database Settings

Edit `config/database.yml` if you need different credentials:

```yaml
default: &default
  host: localhost
  port: 5432
  database: her_finance_db
  user: finance_user
  password: her_finance_password
```

### 3. Set Up the Database

Run the setup script to create the database and tables:

```bash
./scripts/setup.sh
```

This will:
- Create the `her_finance_db` database
- Create all necessary tables
- Insert sample data for testing

### 4. Start Jupyter Notebook

```bash
jupyter notebook
```

Navigate to `notebooks/queries.ipynb` and start analyzing your data!

### 5. Clean Up (Optional)

When you're done and want to remove the test database:

```bash
./scripts/cleanup.sh
```

**Note:** Make sure to close all database connections first.

## Database Schema

### Tables

#### person
Stores user profile information.
- `id` - Primary key
- `name` - User's full name
- `email` - Email address (unique)
- `created_at` - Timestamp of record creation

#### income_categories
Defines types of income sources.
- `id` - Primary key
- `name` - Category name (e.g., "Salary", "Bonuses")
- `description` - Category description

#### income_transactions
Records individual income transactions.
- `id` - Primary key
- `person_id` - Foreign key to person
- `category_id` - Foreign key to income_categories
- `amount` - Income amount (decimal)
- `transaction_date` - Date of transaction
- `description` - Transaction notes
- `created_at` - Timestamp of record creation

#### expenses_categories
Defines types of expenses.
- `id` - Primary key
- `name` - Category name (e.g., "Mortgage", "Utilities")
- `description` - Category description

#### expenses_transactions
Records individual expense transactions.
- `id` - Primary key
- `person_id` - Foreign key to person
- `category_id` - Foreign key to expenses_categories
- `amount` - Expense amount (decimal)
- `transaction_date` - Date of transaction
- `description` - Transaction notes
- `created_at` - Timestamp of record creation

## Usage Examples

### Connecting to the Database

#### Using Python
```python
import psycopg2

conn = psycopg2.connect(
    dbname="her_finance_db",
    user="finance_user",
    password="her_finance_password",
    host="localhost",
    port=5432
)
```

#### Using psql CLI
```bash
psql -U finance_user -d her_finance_db
```

### Sample Queries

#### Total Income by Person
```sql
SELECT 
    p.name,
    SUM(it.amount) as total_income
FROM person p
JOIN income_transactions it ON p.id = it.person_id
GROUP BY p.name;
```

#### Expenses by Category
```sql
SELECT 
    ec.name as category,
    SUM(et.amount) as total_amount
FROM expenses_categories ec
JOIN expenses_transactions et ON ec.id = et.category_id
GROUP BY ec.name
ORDER BY total_amount DESC;
```

#### Net Income (Savings)
```sql
SELECT 
    p.name,
    COALESCE(SUM(it.amount), 0) as income,
    COALESCE(SUM(et.amount), 0) as expenses,
    COALESCE(SUM(it.amount), 0) - COALESCE(SUM(et.amount), 0) as savings
FROM person p
LEFT JOIN income_transactions it ON p.id = it.person_id
LEFT JOIN expenses_transactions et ON p.id = et.person_id
GROUP BY p.name;
```

## Configuration

### Database Configuration

The `config/database.yml` file contains database connection settings for different environments:

- **development** - Local development database
- **test** - Separate test database
- **production** - Production database (use environment variables)

### Environment-Specific Settings

For production, override settings with environment variables rather than hardcoding credentials:

```bash
export DB_NAME="her_finance_db"
export DB_USER="finance_user"
export DB_PASSWORD="secure_password"
export DB_HOST="localhost"
export DB_PORT="5432"
```

## Troubleshooting

### Database Connection Issues

**Problem:** Can't connect to PostgreSQL
```bash
psql: error: connection to server on socket "/tmp/.s.PGSQL.5432" failed
```

**Solution:** Ensure PostgreSQL is running
```bash
brew services list
brew services start postgresql
```

### Permission Errors

**Problem:** `permission denied for database`

**Solution:** Grant proper permissions to the user
```sql
GRANT ALL PRIVILEGES ON DATABASE her_finance_db TO finance_user;
```

### Database Already Exists

**Problem:** `database "her_finance_db" already exists`

**Solution:** Either use the existing database or drop it first
```bash
./scripts/cleanup.sh
./scripts/setup.sh
```

### Active Connections Preventing Cleanup

**Problem:** `database "her_finance_db" is being accessed by other users`

**Solution:** Check and close active connections
```bash
# See active connections
psql -U finance_user -d her_finance_db -c "SELECT pid, usename, application_name FROM pg_stat_activity WHERE datname = 'her_finance_db';"

# Close connections (replace PID with actual process ID)
psql -U finance_user -d her_finance_db -c "SELECT pg_terminate_backend(PID);"
```

Or close connections in your Jupyter notebook before running cleanup.

## Development

### Adding New Features

1. **New Income/Expense Categories**
   - Add entries to `sql/sample_data.sql`
   - Re-run setup script

2. **New Tables**
   - Define schema in `sql/schema.sql`
   - Update sample data if needed
   - Document in this README

3. **New Queries**
   - Add to Jupyter notebook
   - Document common patterns

### Testing

After making schema changes:

```bash
# Clean up old database
./scripts/cleanup.sh

# Set up fresh database with new schema
./scripts/setup.sh

# Test queries in notebook
jupyter notebook
```

## Best Practices

1. **Security**
   - Never commit passwords to version control
   - Use environment variables for production
   - Regularly backup your database

2. **Data Entry**
   - Use consistent category names
   - Include descriptions for clarity
   - Record transactions promptly

3. **Analysis**
   - Close database connections when done
   - Save notebook outputs regularly
   - Document custom queries

4. **Maintenance**
   - Regularly review and categorize transactions
   - Archive old data periodically
   - Keep schema documentation updated

## Contributing

To contribute to this project:

1. Create a new branch for your feature
2. Make your changes
3. Test thoroughly
4. Update documentation
5. Submit a pull request

## License

This project is for personal use. Modify as needed for your own finance tracking needs.

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review the README files in subdirectories
3. Examine the sample data and queries in the notebooks

## Roadmap

Future enhancements:
- [ ] Web interface for data entry
- [ ] Automated transaction imports
- [ ] Budget tracking and alerts
- [ ] Monthly/yearly reports
- [ ] Export to CSV/Excel
- [ ] Multi-currency support
- [ ] Investment tracking
- [ ] Tax category tagging

## Acknowledgments

Built with:
- PostgreSQL - Database
- Python - Data analysis
- Pandas - Data manipulation
- Plotly - Interactive visualizations
- Jupyter - Interactive notebooks
