php-fpm:
  pkg.installed:
    - name: php-fpm
    - require:
      - pkg: php

  # Configuring PHP-FPM processes is up to the individual applications
  # So removing the default defined example process
  file.absent:
    - name: /etc/php-fpm.d/www.conf

php-fpm.service:
  service.running:
    - name:   php-fpm
    - enable: True
    - reload: True
    - require:
      - pkg:  php-fpm
    - watch:
      - pkg:  php-fpm
      - file: /etc/php-fpm.d/*
      - file: /etc/php.ini
      - file: /etc/php.d/*
