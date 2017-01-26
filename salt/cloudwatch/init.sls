cloudwatch:
  pip.installed:
    - name: awscli

/home/{{ pillar.dcmn.user }}/.aws/cloudwatch-config:
  file.managed:
    - source: salt://cloudwatch/config
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

/home/{{ pillar.dcmn.user }}/cloudwatch-monitoring:
  file.managed:
    - source: salt://cloudwatch/cloudwatch-monitoring
    - user: {{ pillar.dcmn.user }}
    - group: {{ pillar.dcmn.group }}
    - file_mode: 600

bash /home/{{ pillar.dcmn.user }}/cloudwatch-monitoring > /dev/null:
  cron.present:
    - identifier: CLOUDWATCH
    - user: {{ pillar.dcmn.user }}
