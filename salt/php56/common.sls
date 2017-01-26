include:
  - rhscl

php56:
  pkgrepo.managed:
    - humanname: PHP 5.6 - epel-7-x86_64
    - baseurl: https://www.softwarecollections.org/repos/rhscl/rh-php56/epel-7-x86_64/
    - gpgcheck: 0
    - require_in:
      - pkg: php56

  pkg.installed:
    - pkgs:
      - rh-php56-php-common
      - rh-php56-php-cli
      - rh-php56-php-xml

  cmd.run:
    - name:   scl enable rh-php56 "php -r \"readfile('https://getcomposer.org/installer');\" | php -- --install-dir='/opt/rh/rh-php56/root/usr/bin' --filename='composer'"
    - unless: scl enable rh-php56 "/opt/rh/rh-php56/root/usr/bin/composer self-update"
    - env:
      - HOME: '/root'
    - require:
      - pkg: php56

  file.managed:
    - name: /etc/opt/rh/rh-php56/php.ini
    {% if '-dev-' in grains['id'] %}
    - source: salt://php56/php-dev.ini
    {% else %}
    - source: salt://php56/php.ini
    {% endif %}
    - require:
      - pkg: php56

php56-opcache:
  pkg.installed:
    - name: rh-php56-php-opcache
    - require:
      - pkg: php56

  file.managed:
    - name: /etc/opt/rh/rh-php56/php.d/10-opcache.ini
    {% if '-dev-' in grains['id'] %}
    - source: salt://php56/opcache-dev.ini
    {% else %}
    - source: salt://php56/opcache.ini
    {% endif %}
    - require:
      - pkg: php56-opcache

{% if '-dev-' in grains['id'] %}
php56-xdebug:
  pkg.installed:
    - name: rh-php56-php-pecl-xdebug
    - require:
      - pkg: php56

  file.managed:
    - name:   /etc/opt/rh/rh-php56/php.d/15-xdebug.ini
    - source: salt://php56/xdebug.ini
    - require:
      - pkg: php56-xdebug
{% endif %}
