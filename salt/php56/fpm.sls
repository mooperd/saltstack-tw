php56-fpm:
  pkg.installed:
    - name: rh-php56-php-fpm
    - require:
      - pkg: php56

  # Configuring PHP-FPM processes is up to the individual applications
  # So removing the default defined example process
  file.absent:
    - name: /etc/opt/rh/rh-php56/php-fpm.d/www.conf

php56-fpm.service:
  service.running:
    - name:   rh-php56-php-fpm
    - enable: True
    - reload: True
    - require:
      - pkg:  php56-fpm
    - watch:
      - pkg:  php56-fpm
      - file: /etc/opt/rh/rh-php56/php-fpm.d/*
      - file: /etc/opt/rh/rh-php56/php.ini
      - file: /etc/opt/rh/rh-php56/php.d/*
