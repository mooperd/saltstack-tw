
# install rsyslog client.
# N.B. communication with the Rsyslog 'server' is unencrypted.
/etc/rsyslog.conf:
  file.managed:
    - source: salt://rsyslog-client/rsyslog.conf
    - template: jinja

# When using Vagrant the ip of the master must be put in manually.
rsyslog:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True # Verdammt! This is not restarting the process!
    - require:
      - pkg: rsyslog
    - watch:
      - file: /etc/rsyslog.conf

systemctl restart rsyslog:
  cmd.run
