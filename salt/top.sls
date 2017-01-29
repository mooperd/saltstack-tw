base:

  # This should be installed on all instances
  '*':
    - base
    - ntp
    - tools

  # This should be installed on all production instances
  'web*':
    - frontend
    - newsfeed
    - quotes
    - nginx
