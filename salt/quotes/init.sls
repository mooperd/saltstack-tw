quotes.jar:
  file.managed:
    - name:   /home/centos/bin/quotes.jar
    - source: salt://quotes/quotes.jar
    - makedirs: True

/usr/lib/systemd/system/quotes.service:
  file.managed:
    - name:   /usr/lib/systemd/system/quotes.service
    - source: salt://quotes/quotes.service

quotes.service:
  service.running:
    - name:   quotes
    - enable: True
    - reload: True
