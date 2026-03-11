# Используем официальный PHP-образ с Apache
FROM php:8.2-apache

# Копируем код приложения в контейнер
COPY src/ /var/www/html/

# Включаем mod_rewrite для Apache (может понадобиться для Laravel)
RUN a2enmod rewrite

# Указываем, что контейнер слушает на порту 80
EXPOSE 80
