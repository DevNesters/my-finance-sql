# Configuration Files

This directory contains configuration files for the personal finance application.

## Files

### database.yml

Database configuration for PostgreSQL connection across different environments.

**Environments:**
- `development`: Local development database
- `test`: Separate test database to avoid interfering with development data
- `production`: Production database (should use environment variables for sensitive credentials)

**Configuration:**
- Host: localhost
- Port: 5432 (PostgreSQL default)
- Database: her-finance_db
- User: panhiayang

**Security Notes:**
- The password is currently hardcoded in the file
- For production deployments, override credentials using environment variables
- Never commit production credentials to version control

## Setup

1. Ensure PostgreSQL is installed and running
2. Create the databases:
   ```bash
   createdb her-finance_db
   createdb her-finance_db_test
   ```
3. Update credentials in `database.yml` if needed
4. For production, set environment variables to override default values
