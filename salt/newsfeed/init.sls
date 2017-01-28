/usr/lib/systemd/system/newsfeed.service:
  file.managed:
    - name:   /usr/lib/systemd/system/newsfeed.service
    - source: salt://frontend/newsfeed.service

newsfeed.service:
  service.running:
    - name:   newsfeed
    - enable: True
    - reload: True
