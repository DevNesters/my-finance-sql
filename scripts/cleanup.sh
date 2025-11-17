#!/bin/bash
set -e
set -o nounset
set -o pipefail

# ----------------------------------------------
# Read from database.yml
# ----------------------------------------------
DB_NAME=$(yq eval '.development.database' config/database.yml)
DB_USER=$(yq eval '.development.user' config/database.yml)

# ----------------------------------------------
# Cleanup Script
# Drops the database and user created during setup
# ----------------------------------------------

echo "Dropping database $DB_NAME..."
psql -U panhiayang -d template1 -c "DROP DATABASE IF EXISTS $DB_NAME;"
echo "Database dropped."

echo "Dropping user $DB_USER..."
psql -U panhiayang -d template1 -c "DROP ROLE IF EXISTS $DB_USER;"
echo "User dropped."

echo "Cleanup complete!"