# manage DH (Diffie-Hellman) params file

ssl.dhparam.pem:
  file.managed:
    - name:   /etc/ssl/dhparam.pem
    - source: salt://ssl/dhparam.pem
    - makedirs:  True
    - mode:      600
    - require_in:
      - service: nginx.service
    - watch_in:
      - service: nginx.service
