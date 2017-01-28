/usr/lib/systemd/system/frontend.service:
  file.managed:
    - name:   /usr/lib/systemd/system/frontend.service
    - source: salt://frontend/frontend.service

frontend.service:
  service.running:
    - name:   frontend
    - enable: True
    - reload: True
