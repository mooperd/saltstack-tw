{%- from "common.jinja" import vars with context %}

etc-sysconfig-network:
  cmd.run:
    - name: echo -e "NETWORKING=yes\nHOSTNAME={{ vars.hostname }}\n" > /etc/sysconfig/network
    - unless: test -f /etc/sysconfig/network
  file.replace:
    - name: /etc/sysconfig/network
    - pattern: HOSTNAME=localhost.localdomain
    - repl: HOSTNAME={{ vars.fqdn }}

/etc/hostname:
  file.managed:
    - contents: {{ vars.fqdn }}
    - backup: false

hostname {{ vars.fqdn }}:
  cmd.run

/etc/hosts:
  file.append:
    - text:
      - "{{ vars.ip }} {{ vars.fqdn }}"

fix-cloud-conf-set-host:
  file.replace:
    - name: /etc/cloud/cloud.cfg
    - pattern: "- set_hostname"
    - repl: "# - set_hostname"

fix-cloud-conf-update-host:
  file.replace:
    - name: /etc/cloud/cloud.cfg
    - pattern: "- update_hostname"
    - repl: "# - update_hostname"

/etc/dhcp/dhclient-exit-hooks:
  file.managed:
    - source: salt://hostname/dhclient-exit-hooks
    - mode: 711
