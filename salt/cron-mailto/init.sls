cron_mailto:
  cron.env_present:
    - user: {{ pillar.dcmn.user }}
    - name: MAILTO
    - value: {{ pillar.dcmn.alert.email }}
