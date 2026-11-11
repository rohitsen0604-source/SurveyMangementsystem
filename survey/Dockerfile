FROM php:8.1-apache

# Set non-interactive debian frontend
ENV DEBIAN_FRONTEND=noninteractive

# Update packages and install MariaDB server & client
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Install mysqli PHP extension
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# Enable Apache modules
RUN a2enmod rewrite headers

# Create directory structures with proper permissions
RUN mkdir -p /var/run/mysqld /var/lib/mysql /var/www/html/assets/uploads \
    && chown -R mysql:mysql /var/run/mysqld /var/lib/mysql \
    && chmod 777 /var/run/mysqld

# Copy application files into web root
COPY . /var/www/html/

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Fix line endings and make entrypoint executable
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh && chmod +x /usr/local/bin/entrypoint.sh

# Set file permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/assets/uploads

# Default Environment Variables for Render
ENV PORT=80 \
    DB_HOST=127.0.0.1 \
    DB_USER=root \
    DB_PASSWORD="" \
    DB_NAME=survey_db \
    DB_PORT=3306

# Expose default port
EXPOSE 80

# Execute entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

