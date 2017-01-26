php-mysql:
  pkg.installed:
    - pkgs:
      - php-mysqlnd
      - php-pdo

# Don't load the deprecated PHP extension "mysql"
# (All possible MySQL extensions will be installed by "rh-php56-php-mysqlnd")
php-mysql.absent:
  file.absent:
    - name: /etc/php.d/mysqlnd_mysql.ini
