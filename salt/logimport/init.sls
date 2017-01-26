/root/log-import-stuff:
  file.recurse:
    - source: salt://logimport/log-import-stuff
    - makedirs: True
    - include_empty: True
