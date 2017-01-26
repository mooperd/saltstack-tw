base:
  '*':
    - dcmn

  '*-prod-*':
    - ip
    - freeipa
    - aws_keys

  '*-staging-*':
    - ip
    - freeipa
    - aws_keys

  # Salt Master
  'master':
    - ip
    - aws_keys
    - freeipa

  # Piwik
  'piwik-dev-*':
    - piwik-dev

  'piwik-testing-*':
    - piwik-testing

  'piwik-staging-*':
    - piwik-staging

  'piwik-prod-*':
    - piwik-prod

  # API
  'api-dev-*':
    - api-dev

  'api-testing-*':
    - api-testing

  'api-staging-*':
    - api-staging

  'api-prod-*':
    - api-prod
