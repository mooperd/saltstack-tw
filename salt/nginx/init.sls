nginx:
  pkg.installed: []

nginx.conf:
  file.managed:
    - name:   /etc/nginx/nginx.conf
    - source: salt://nginx/nginx.conf
    - require:
      - pkg: nginx

nginx.service:
  service.running:
    - name:   nginx
    - enable: True
    - reload: True
    - require:
      - pkg:  nginx
    - watch:
      - pkg:  nginx
      - file: /etc/nginx/nginx.conf

# make SELinux allow nginx to connect to service.
setsebool httpd_can_network_connect 1 -P:
  cmd.run
