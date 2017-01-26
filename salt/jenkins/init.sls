
java-1.8.0-openjdk:
  pkg.installed: []

wget:
  pkg.installed: []

jq:
  pkg.installed: []

jenkins:
  pkgrepo.managed:
    - humanname: Jenkins upstream package repository
    - baseurl: http://pkg.jenkins-ci.org/redhat
    - gpgkey: http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
    - require_in:
      - pkg: jenkins
  pkg.latest:
    - refresh: True
  service.running:
    - enable: True
    - watch:
      - pkg: jenkins

gspread:
  pkg.installed
