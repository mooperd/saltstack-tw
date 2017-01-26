php-geoip:
  pkg.installed:
    - pkgs:
      - php-pecl-geoip
    - require:
      - pkg: geoip

  file.managed:
    - name:   /etc/php.d/geoip.ini
    - source: salt://php/geoip.ini
    - require:
      - pkg: php-geoip
      - pkg: geoip
