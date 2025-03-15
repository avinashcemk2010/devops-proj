# Use official PHP image with Apache
FROM php:8.1-apache

# Install required extensions
RUN docker-php-ext-install pdo pdo_mysql

# Copy application files to Apache document root
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
