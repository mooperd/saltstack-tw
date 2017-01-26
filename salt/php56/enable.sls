php56.enable:
  file.managed:
    - name:   /etc/profile.d/rh-php56.sh
    - source: salt://php56/enable.sh
    - require:
      - pkg: php56
