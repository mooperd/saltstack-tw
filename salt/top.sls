base:

  # This should be installed on all instances
  '*':
    - base
    - ntp
    - tools
    - users

  # This should be installed on all production instances
  '*-prod-*':
    - hostname
    - cloudwatch
    - cron-mailto

  # This should be installed on all testing instances
  '*-testing-*':
    - hostname
    - cloudwatch

  # This should be installed on all testing instances
  '*-staging-*':
    - hostname
    - cloudwatch

  # The salt master
  'master':
    - hostname
    - cloudwatch
    - salt-cloud

  'rhel-freeipa-*':
    - freeipa-replica

  # The API (api.dcmn.com)
  # TODO: selinux.enforcing
  'api-*':
    - selinux.permissive
    - nginx
    - ssl.dcmn-com
    - ssl.dhparam
    - php56.common
    - php56.mysql
    - php56.fpm
    - php56.enable
    - api

  # t.dcmn.com
  'tracktor-*':
    - s3
    - nginx
    - ssl.dcmn-com
    - ssl.dhparam
    - tracktor

  # report.dcmn.com
  'piwik-*':
    - selinux.disabled
    - geoip
    - nginx
    - php.common
    - php.mysql
    - php.intl
    - php.mbstring
    - php.geoip
    - php.gd
    - php.fpm
    - piwik

  'piwik-(testing|staging|prod)-*':
    - match: pcre
    - s3
    - sync-codes
