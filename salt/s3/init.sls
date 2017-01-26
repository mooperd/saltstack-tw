s3:
  pip.installed:
    - name: awscli

/home/{{ pillar.dcmn.user }}/.aws/s3-config:
  file.managed:
    - source: salt://s3/config
    - template: jinja
    - user: {{ pillar.dcmn.user }}
    - group: {{ pillar.dcmn.group }}
    - file_mode: 600
    - dir_mode: 700
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
