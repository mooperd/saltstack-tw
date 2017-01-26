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
      - file: /etc/nginx/conf.d/*
