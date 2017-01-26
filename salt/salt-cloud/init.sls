yum install salt-cloud -y:
  cmd.run

# Write the salt cloud.providers file which describes our commercial cloud
# providers
/etc/salt/cloud.providers:
  file.managed:
    - source: salt://salt-cloud/cloud.providers
    - template: jinja

# Write the salt cloud.profiles file which describes the parameters of
# new instances
/etc/salt/cloud.profiles:
  file.managed:
    - source: salt://salt-cloud/cloud.profiles

/etc/salt/amazon.pem:
  file.managed:
    - source: salt://salt-cloud/amazon.pem
    - mode: 400
