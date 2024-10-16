#!/bin/bash

# Check if WP-CLI is installed
if ! command -v wp &> /dev/null
then
    echo "WP-CLI is not installed. Please install it first."
    exit 1
fi

# Check for MySQL client
MYSQL_CMD="mysql"
if ! command -v mysql &> /dev/null; then
    echo "MySQL client not found. Please ensure DBngin is installed and running, or install MySQL client."
    exit 1
fi

# Set variables
DB_USER="root"  # DBngin typically uses root without password by default
DB_PASSWORD=""  # Empty password as per DBngin default
DB_HOST="127.0.0.1"
WP_TITLE="My WordPress Site"
WP_ADMIN_USER="admin"
WP_ADMIN_PASSWORD="password"
WP_ADMIN_EMAIL="admin@example.com"

# Prompt for new site folder
read -p "Enter the new site folder name: " SITE_NAME

# Validate folder name input
if [ -z "$SITE_NAME" ]; then
    echo "Folder name cannot be empty. Exiting."
    exit 1
fi

# Create new site directory
mkdir -p "$HOME/Herd/$SITE_NAME" && cd "$HOME/Herd/$SITE_NAME" || exit

# Automatically use SITE_NAME for URL and DB name
WP_URL="$SITE_NAME.test"
DB_NAME="$SITE_NAME"

# Output the generated values
echo "Using the following values:"
echo "WordPress URL: $WP_URL"
echo "Database Name: $DB_NAME"

# Create database
"$MYSQL_CMD" -h"$DB_HOST" -u"$DB_USER" -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
if [ $? -ne 0 ]; then
    echo "Failed to create database. Please check your DBngin setup and ensure MySQL is running."
    exit 1
fi

# Download WordPress core
wp core download

# Create wp-config.php
wp config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost="$DB_HOST"

# Install WordPress
wp core install --url="$WP_URL" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_ADMIN_EMAIL"

echo "WordPress core installation complete!"
echo "Site URL: $WP_URL"
echo "Database Name: $DB_NAME"
echo "Admin username: $WP_ADMIN_USER"
echo "Admin password: $WP_ADMIN_PASSWORD"
echo "Remember to change the admin password after logging in!"