freeipa-pkgs:
  pkg.installed:
    - pkgs:
      - bind-utils
      - bind-dyndb-ldap 
      - ipa-server 
      - openvpn
      - firewalld

firewalld:
  pkg.installed: []
  service.running:
    - enable: True

# ln -s /etc/pam.d/system-auth /etc/pam.d/openvpn

{% if not salt['file.directory_exists' ]('/etc/pam.d/openvpn') %}
symlink:
  file.symlink:
    - name: /etc/pam.d/openvpn
    - target: /etc/pam.d/system-auth
{% endif %}

openvpn-config:
  file.recurse:
    - user: root
    - group: root
    - source: salt://freeipa-replica/openvpn
    - name: /etc/openvpn
    - dir_mode: 770
    - file_mode: 660
    - makedirs: True
    - include_empty: True
    - require:
      - pkg: freeipa-pkgs

openvpn-certs:
  file.recurse:
    - user: root
    - group: root
    - source: salt://freeipa-replica/openvpn-certs
    - name: /etc/openvpn
    - file_mode: 400
    - makedirs: True
    - include_empty: True
    - require:
      - pkg: freeipa-pkgs
      - file: openvpn-config

/etc/httpd/conf.d/welcome.conf:
  file.managed:
    - source: salt://freeipa-replica/welcome.conf
    - file_mode: 400
    - user: root
    - group: root
    - require:
      - pkg: freeipa-pkgs

/etc/httpd/conf.d/monitor.conf:
  file.managed:
    - source: salt://freeipa-replica/monitor.conf
    - file_mode: 400
    - user: root
    - group: root
    - require:
      - pkg: freeipa-pkgs

systemctl is-active openvpn@server > /var/www/html/healthcheck.txt:
  cron.present:
    - identifier: MONITOR
    - user: root 

for s in ntp http https ldap ldaps kerberos kpasswd openvpn dns; do firewall-cmd --permanent --add-service=$s; done:
  cmd.run:
    - require:
      - pkg: firewalld

firewall-cmd --zone=public --add-port=81/tcp --permanent:
  cmd.run:
    - require:
      - pkg: firewalld

firewall-cmd --permanent --add-masquerade:
  cmd.run:
    - require:
      - pkg: firewalld

firewall-cmd --reload:
  cmd.run:
    - order: last
