FROM registry.dexter.com.br:5000/dexter-wordpress

COPY wp-content /var/www/html/wp-content

RUN chown -R www-data.www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
