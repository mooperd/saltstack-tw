base:

  # This should be installed on all instances
  '*':
    - base
    - ntp
    - tools

  # This should be installed on all production instances
  'wibble*':
    - frontend
    - newsfeed
    - quote
    - nginx
