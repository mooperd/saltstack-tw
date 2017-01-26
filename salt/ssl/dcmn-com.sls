# manage SSL certificate files for *.dcmn.com

ssl.dcmn-com.key:
  file.managed:
    - name: /etc/ssl/dcmn-com.key
    - source:
      - salt://ssl/dcmn-com.key
      - salt://ssl/dummy.key
    - makedirs: True
    - mode: 600
    - require_in:
      - service: nginx.service
    - watch_in:
      - service: nginx.service

ssl.dcmn-com.crt:
  file.managed:
    - name: /etc/ssl/dcmn-com.crt
    - source:
      - salt://ssl/dcmn-com.crt
      - salt://ssl/dummy.crt
    - makedirs: True
    - mode: 600
    - require_in:
      - service: nginx.service
    - watch_in:
      - service: nginx.service
