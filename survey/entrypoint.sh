#!/bin/bash
set -e

# Configure Apache port based on Render dynamic $PORT (defaults to 80 if not set)
PORT="${PORT:-80}"
echo "==> [Entrypoint] Configuring Apache to listen on port ${PORT}..."
sed -i "s/Listen [0-9]*/Listen ${PORT}/" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:[0-9]*>/<VirtualHost \*:${PORT}>/" /etc/apache2/sites-available/000-default.conf

# Database connection settings
DB_HOST="${DB_HOST:-127.0.0.1}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"
DB_NAME="${DB_NAME:-survey_db}"
DB_PORT="${DB_PORT:-3306}"

# Check if internal or external database is used
if [ "$DB_HOST" = "127.0.0.1" ] || [ "$DB_HOST" = "localhost" ]; then
    echo "==> [Entrypoint] Running embedded MariaDB database service..."
    mkdir -p /var/run/mysqld /var/lib/mysql
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql
    chmod 777 /var/run/mysqld

    # Initialize MariaDB system tables if needed
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        echo "==> [Entrypoint] Initializing MariaDB system tables..."
        mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1 || mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1 || true
    fi

    # Start MariaDB service
    echo "==> [Entrypoint] Starting MariaDB daemon..."
    if [ -x "/etc/init.d/mariadb" ]; then
        /etc/init.d/mariadb start
    elif [ -x "/etc/init.d/mysql" ]; then
        /etc/init.d/mysql start
    else
        service mariadb start || service mysql start
    fi

    # Wait for MariaDB to accept connections
    echo "==> [Entrypoint] Waiting for MariaDB service to be ready..."
    for i in {1..30}; do
        if mysqladmin ping --silent 2>/dev/null; then
            echo "==> [Entrypoint] MariaDB is up and ready!"
            break
        fi
        sleep 1
    done

    # Setup database and user authentication
    echo "==> [Entrypoint] Configuring database '${DB_NAME}' and permissions..."
    mysql -u root <<EOSQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${DB_PASSWORD}');
CREATE USER IF NOT EXISTS 'root'@'127.0.0.1' IDENTIFIED VIA mysql_native_password USING PASSWORD('${DB_PASSWORD}');
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOSQL

    # Check if database has tables; if empty, import survey_db.sql
    TABLE_COUNT=$(mysql -u root ${DB_PASSWORD:+-p"$DB_PASSWORD"} -e "USE \`${DB_NAME}\`; SHOW TABLES;" 2>/dev/null | wc -l || echo 0)
    if [ "$TABLE_COUNT" -le 1 ]; then
        echo "==> [Entrypoint] Database '${DB_NAME}' is empty. Importing schema from survey_db.sql..."
        if [ -f "/var/www/html/database/survey_db.sql" ]; then
            mysql -u root ${DB_PASSWORD:+-p"$DB_PASSWORD"} "${DB_NAME}" < /var/www/html/database/survey_db.sql
            echo "==> [Entrypoint] Schema imported successfully!"
        fi
    else
        echo "==> [Entrypoint] Database '${DB_NAME}' already contains tables (${TABLE_COUNT}). Skipping import."
    fi

else
    echo "==> [Entrypoint] External database specified: ${DB_HOST}:${DB_PORT}"
    echo "==> [Entrypoint] Checking connectivity to external MySQL..."
    for i in {1..20}; do
        if mysqladmin ping -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" ${DB_PASSWORD:+-p"$DB_PASSWORD"} --silent 2>/dev/null; then
            echo "==> [Entrypoint] Successfully connected to external database!"
            mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" ${DB_PASSWORD:+-p"$DB_PASSWORD"} -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;" 2>/dev/null || true
            EXT_TABLES=$(mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" ${DB_PASSWORD:+-p"$DB_PASSWORD"} "$DB_NAME" -e "SHOW TABLES;" 2>/dev/null | wc -l || echo 0)
            if [ "$EXT_TABLES" -le 1 ] && [ -f "/var/www/html/database/survey_db.sql" ]; then
                echo "==> [Entrypoint] Importing survey_db.sql into external database..."
                mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" ${DB_PASSWORD:+-p"$DB_PASSWORD"} "$DB_NAME" < /var/www/html/database/survey_db.sql 2>/dev/null || true
                echo "==> [Entrypoint] External database schema initialized!"
            fi
            break
        fi
        echo "==> [Entrypoint] Waiting for external database at ${DB_HOST}:${DB_PORT} ($i/20)..."
        sleep 2
    done
fi

# Ensure uploads directory has correct permissions
mkdir -p /var/www/html/assets/uploads
chown -R www-data:www-data /var/www/html/assets/uploads
chmod -R 777 /var/www/html/assets/uploads

echo "==> [Entrypoint] Survey Management System setup complete!"
echo "==> [Entrypoint] Starting Apache in foreground on port ${PORT}..."
exec apache2-foreground
