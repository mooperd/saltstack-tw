piwik.nginx.conf:
  file.managed:
    - name:   /etc/nginx/conf.d/piwik.conf
    - source: salt://piwik/piwik.nginx.conf
    - require:
      - pkg:  nginx

piwik.php-fpm.conf:
  file.managed:
    - name:   /etc/php-fpm.d/piwik.conf
    - source: salt://piwik/piwik.php-fpm.conf
    - require:
      - pkg: php-fpm

# If running on VirtialBox -> assume vagrant
# setup code
{% if grains['virtual'] != 'VirtualBox' %}

/usr/share/nginx/piwik:
  file.recurse:
    - user: nginx
    - group: nginx
    - source: salt://piwik/piwik
    - dir_mode: 775
    - file_mode: 664
    - makedirs: True
    - include_empty: True
    - require:
      - pkg: nginx
    - require_in:
      - service: php-fpm.service

/usr/share/nginx/piwik/html/config/config.ini.php:
  file.managed:
    - source: salt://piwik/piwik/html/config/config.dist.ini.php
    - template: jinja
    - user: {{ pillar.dcmn.user }}
    - group: {{ pillar.dcmn.group }}
    - mode: 644
    - require_in:
      - service: php-fpm.service

{% else %}

/usr/share/nginx/piwik/html/config/config.ini.php:
  file.managed:
    - source: /usr/share/nginx/piwik/html/config/config.dist.ini.php
    - template: jinja
    - user: {{ pillar.dcmn.user }}
    - group: {{ pillar.dcmn.group }}
    - require_in:
      - service: php-fpm.service

{% endif %}
