/home/centos/tracking-codes/sync-codes > /dev/null:
  cron.present:
    - identifier: CODE-SYNC
    - user: centos
    - minute: '*/10'

/home/centos/tracking-codes:
  file.recurse:
    - source: salt://sync-codes/tracking-codes
    - user: centos
    - group: centos
    - file_mode: 777
    - dir_mode: 777
    - include_empty: True
