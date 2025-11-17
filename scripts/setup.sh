#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status
set -o nounset # Treat unset variables as an error
set -o pipefail # Prevent errors in a pipeline from being masked

# ----------------------------------------------
# Cleanup on error
# ----------------------------------------------
trap 'echo "An error occurred during setup at line $LINENO: $BASH_COMMAND"; ./cleanup.sh; exit 1' ERR

# -------------------------
# Config variables
# -------------------------
# Read from database.yml
DB_HOST=$(yq eval '.development.host' config/database.yml)
DB_PORT=$(yq eval '.development.port' config/database.yml)
DB_NAME=$(yq eval '.development.database' config/database.yml)
DB_USER=$(yq eval '.development.user' config/database.yml)
DB_PASS=$(yq eval '.development.password' config/database.yml)
SCHEMA_FILE=$(yq eval '.development.schema_file' config/database.yml)
DATA_FILE=$(yq eval '.development.data_file' config/database.yml)

# -------------------------
# 1. Create user if not exists
# -------------------------
USER_EXISTS=$(psql -U panhiayang -d template1 -tAc "SELECT 1 FROM pg_roles WHERE rolname='${DB_USER}'")
if [ "$USER_EXISTS" != "1" ]; then
  echo "Creating database user '${DB_USER}'..."
  psql -U panhiayang -d template1 -c "CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASS}';"
else
  echo "Database user '${DB_USER}' already exists. Skipping creation."
fi

# -------------------------
# 2. Create database if not exists
# -------------------------
DB_EXISTS=$(psql -U panhiayang -d template1 -tAc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'")
if [ "$DB_EXISTS" != "1" ]; then
  echo "Creating database '${DB_NAME}'..."
  psql -U panhiayang -d template1 -c "CREATE DATABASE ${DB_NAME} OWNER ${DB_USER};"
else
  echo "Database '${DB_NAME}' already exists. Skipping creation."
fi

# -------------------------
# 3. Grant privileges
# -------------------------
echo "Granting all privileges on database '${DB_NAME}' to user '${DB_USER}'..."
psql -U panhiayang -d template1 -c "GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};"

# -------------------------
# 4. Run schema & sample data
# -------------------------
echo "Running schema.sql..."
psql -U $DB_USER -d $DB_NAME -f $SCHEMA_FILE

echo "Running sample_data.sql..."
psql -U $DB_USER -d $DB_NAME -f $DATA_FILE

echo "Project setup complete!"