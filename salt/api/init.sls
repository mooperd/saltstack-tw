api.php-fpm.conf:
  file.managed:
    - name:   /etc/opt/rh/rh-php56/php-fpm.d/api.conf
    - source: salt://api/api.php-fpm.conf
    - require:
      - pkg: php56-fpm

api.nginx.conf:
  file.managed:
    - name:   /etc/nginx/conf.d/api.conf
    - source: salt://api/api.nginx.conf
    - require:
      - pkg:  nginx
      - file: ssl.dcmn-com.key
      - file: ssl.dcmn-com.crt
      - file: ssl.dhparam.pem
      - file: api.php-fpm.conf

# If running on VirtialBox -> assume vagrant
# setup code
{% if grains['virtual'] != 'VirtualBox' %}

api.code.copy:
  file.recurse:
    - name: /usr/share/nginx/api
    - source: salt://api/api
    - user: {{ pillar.dcmn.user }}
    - group: {{ pillar.dcmn.group }}
    - dir_mode: 775
    - file_mode: 664
    - makedirs: True
    - include_empty: True
    - exclude_pat: .git*
    - require:
      - pkg: nginx
      - pkg: php56-fpm
    - require_in:
      - service: php56-fpm.service
      - cmd: api.build.composer
    - watch_in:
      - service: php56-fpm.service

api.build.config:
  file.managed:
    - name:   /usr/share/nginx/api/config/core.module.php
    - source: salt://api/api/config/core.module.dist.php
    - template: jinja
    - user: {{ pillar.dcmn.user }}
    - group: {{ pillar.dcmn.group }}
    - require:
      - pkg: nginx
      - pkg: php56-fpm
    - require_in:
      - service: php56-fpm.service
    - watch_in:
      - service: php56-fpm.service

api.build.ssh.known_host:
  ssh_known_hosts.present:
    - name: github.com
    - user: {{ pillar.dcmn.user }}
    - enc: ssh-rsa
    - key: AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
    - require_in:
      - cmd: api.build.composer

api.build.ssh:
  file.managed:
    - name: /home/{{ pillar.dcmn.user }}/.ssh/it-ci@dcmn.com
    - user: {{ pillar.dcmn.user }}
    - group: {{ pillar.dcmn.group }}
    - mode: 600
    - contents_pillar: dcmn:ssh:deploy:private
    - require_in:
      - cmd: api.build.composer

api.build.ssh.config:
  file.append:
    - name: /home/{{ pillar.dcmn.user }}/.ssh/config
    - makedirs: True
    - text: |
        Host github.com
          User git
          IdentityFile ~/.ssh/it-ci@dcmn.com
          IdentitiesOnly yes
    - require_in:
      - cmd: api.build.composer

api.build.ssh.config_perm:
  file.managed:
    - name: /home/{{ pillar.dcmn.user }}/.ssh/config
    - user: {{ pillar.dcmn.user }}
    - group: {{ pillar.dcmn.group }}
    - mode: 600
    - makedirs: True
    - dir_mode: 0700
    - replace: False
    - require_in:
      - cmd: api.build.composer

{% else %}

api.build.config:
  file.managed:
    - name:   /usr/share/nginx/api/config/core.module.php
    - source: /usr/share/nginx/api/config/core.module.dist.php
    - template: jinja
    - user: {{ pillar.dcmn.user }}
    - group: {{ pillar.dcmn.group }}
    - require:
      - pkg: nginx
      - pkg: php56-fpm
    - require_in:
      - service: php56-fpm.service

{% endif %}

api.build.composer:
  cmd.run:
    {% if '-dev-' in grains['id'] %}
    - name: scl enable rh-php56 "composer install --no-interaction --no-progress --no-ansi"
    {% else %}
    - name: scl enable rh-php56 "composer install --no-interaction --no-progress --no-ansi --no-dev --optimize-autoloader --classmap-authoritative"
    {% endif %}
    - cwd: /usr/share/nginx/api
    - user: {{ pillar.dcmn.user }}
    - require:
      - pkg: php56-fpm
    - require_in:
      - service: php56-fpm.service
    - watch_in:
      - service: php56-fpm.service
