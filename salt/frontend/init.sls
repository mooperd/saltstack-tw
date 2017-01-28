front-end.jar:
  file.managed:
    - name:   /home/centos/bin/front-end.jar
    - source: salt://frontend/front-end.jar
    - makedirs: True

/usr/lib/systemd/system/frontend.service:
  file.managed:
    - name:   /usr/lib/systemd/system/frontend.service
    - source: salt://frontend/frontend.service

frontend.service:
  service.running:
    - name:   frontend
    - enable: True
    - reload: True
