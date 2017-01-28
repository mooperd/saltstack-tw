newsfeed.jar:
  file.managed:
    - name:   /home/centos/bin/newsfeed.jar
    - source: salt://newsfeed/newsfeed.jar
    - makedirs: True

/usr/lib/systemd/system/newsfeed.service:
  file.managed:
    - name:   /usr/lib/systemd/system/newsfeed.service
    - source: salt://newsfeed/newsfeed.service

newsfeed.service:
  service.running:
    - name:   newsfeed
    - enable: True
    - reload: True
