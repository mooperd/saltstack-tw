/usr/lib/systemd/system/quote.service:
  file.managed:
    - name:   /usr/lib/systemd/system/quote.service
    - source: salt://frontend/quote.service

quote.service:
  service.running:
    - name:   quote
    - enable: True
    - reload: True
