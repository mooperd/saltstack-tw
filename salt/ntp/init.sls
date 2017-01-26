ntp:
  pkg.installed:
    - name: ntp

# the chrony deamon conflicts with ntpd
ntp.chrony.removed:
  pkg.removed:
    - name: chrony
    - require_in:
      - pkg: ntp

ntp.conf:
  file.managed:
    - name:   /etc/ntp.conf
    - source: salt://ntp/ntp.conf
    - require:
      - pkg:  ntp

ntpd.service:
  service.running:
    - name:   ntpd
    - enable: True
    - reload: True
    - require:
      - pkg:  ntp
      - file: ntp.conf
    - watch:
      - pkg:  ntp
      - file: /etc/ntp.conf
