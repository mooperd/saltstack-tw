{%- set selinux = "permissive" %}

selinux:
  file.managed:
    - name: /etc/selinux/config
    - source: salt://selinux/config.tpl
    - template: jinja
    - context:
        selinux: {{ selinux }}
  cmd.run:
    - name: setenforce 0

