php:
  pkg.installed:
    - pkgs:
      - php-common
      - php-cli
      - php-xml
      - composer

  file.managed:
    - name: /etc/php.ini
    {% if '-dev-' in grains['id'] %}
    - source: salt://php/php-dev.ini
    {% else %}
    - source: salt://php/php.ini
    {% endif %}
    - require:
      - pkg: php

php-opcache:
  pkg.installed:
    - name: php-pecl-zendopcache
    - require:
      - pkg: php

  file.managed:
    - name: /etc/php.d/opcache.ini
    {% if '-dev-' in grains['id'] %}
    - source: salt://php/opcache-dev.ini
    {% else %}
    - source: salt://php/opcache.ini
    {% endif %}
    - require:
      - pkg: php-opcache

{% if '-dev-' in grains['id'] %}
php-xdebug:
  pkg.installed:
    - name: php-pecl-xdebug
    - require:
      - pkg: php

  file.managed:
    - name:   /etc/php.d/xdebug.ini
    - source: salt://php/xdebug.ini
    - require:
      - pkg: php-xdebug
{% endif %}
