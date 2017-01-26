php56-mysql:
  pkg.installed:
    - pkgs:
      - rh-php56-php-mysqlnd
      - rh-php56-php-pdo

# Don't load the deprecated PHP extension "mysql"
# (All possible MySQL extensions will be installed by "rh-php56-php-mysqlnd")
php56-mysql.absent:
  file.absent:
    - name: /etc/opt/rh/rh-php56/php.d/30-mysql.ini
