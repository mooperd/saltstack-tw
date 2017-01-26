# Add user to group
{{ pillar.dcmn.user }}:
  user.present:
    - groups:
      - nginx

# prepare document root
rm -Rf /usr/share/nginx/html/*:
  cmd.run

/usr/share/nginx/html:
  file.directory:
    - user: {{ pillar.dcmn.user }}
    - group: {{ pillar.dcmn.group }}
    - dir_mode: 755
    - require:
      - pkg: nginx

/usr/share/nginx/html/monitor:
  file.directory:
    - user: {{ pillar.dcmn.user }}
    - group: {{ pillar.dcmn.group }}
    - dir_mode: 755
    - require:
      - pkg: nginx

# prepare log directory
chmod 750 /var/log/nginx:
  cmd.run

/var/log/nginx/tracking:
  file.directory:
    - user: nginx
    - group: nginx
    - mode: 770
    - makedirs: True
    - require:
      - pkg: nginx

# define nginx configuration
tracktor.htpasswd:
  file.recurse:
    - name:   /etc/nginx/htpasswd/
    - source: salt://tracktor/htpasswd
    - dir_mode:  755
    - file_mode: 644
    - require:
      - pkg: nginx
    - require_in:
      - service: nginx.service
    - watch_in:
      - service: nginx.service

tracktor.nginx.conf:
  file.managed:
    - name:   /etc/nginx/conf.d/tracktor.conf
    - source: salt://tracktor/tracktor.nginx.conf
    - require:
      - pkg:  nginx
      - file: ssl.dcmn-com.key
      - file: ssl.dcmn-com.crt
      - file: ssl.dhparam.pem

# Copy scripts
/home/{{ pillar.dcmn.user }}/bin:
  file.recurse:
    - source: salt://tracktor/bin
    - user: {{ pillar.dcmn.user }}
    - group: {{ pillar.dcmn.group }}
    - file_mode: 700
    - dir_mode: 700

# Pull tracking scripts
{% if '-dev-' not in grains['id'] %}
/home/{{ pillar.dcmn.user }}/bin/pull_tracking_scripts.sh:
  cmd.run:
  - user: {{ pillar.dcmn.user }}
  - group: {{ pillar.dcmn.group }}
  - require:
    - file: /home/{{ pillar.dcmn.user }}/bin

/home/{{ pillar.dcmn.user }}/bin/pull_tracking_scripts.sh > /dev/null:
  cron.present:
    - identifier: PULL_TRACKING_SCRIPTS
    - user: {{ pillar.dcmn.user }}
    - minute: '*/15'
    - require:
      - file: /home/{{ pillar.dcmn.user }}/bin
{% endif %}

/home/{{ pillar.dcmn.user }}/bin/update_monitor.sh > /dev/null:
  cron.present:
    - identifier: UPDATE_MONITOR
    - user: {{ pillar.dcmn.user }}
    - minute: '*'
    - require:
      - file: /home/{{ pillar.dcmn.user }}/bin

# last ops
restorecon -Rv /etc/nginx:
  cmd.run:
    - order: last
