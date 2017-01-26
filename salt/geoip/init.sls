geoip:
  pkg.installed:
    - pkgs:
      - GeoIP

geoip.country:
  cmd.run:
    - name: wget -N -nv http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz && gzip -d -c GeoIP.dat.gz > GeoIP.dat.tmp && mv -f GeoIP.dat.tmp GeoIP.dat
    - cwd:  /usr/share/GeoIP
    - require:
      - pkg: geoip
  cron.present:
    - name:       cd /usr/share/GeoIP && wget -N --nv http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz && gzip -d -c GeoIP.dat.gz > GeoIP.dat.tmp && mv -f GeoIP.dat.tmp GeoIP.dat
    - identifier: GEOIP-COUNTRY-UPDATE
    - user:       root
    - dayweek:    4
    - hour:       12
    - minute:     0
    - require:
      - pkg: geoip

geoip.city:
  cmd.run:
    - name: wget -N -nv http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && gzip -d -c GeoLiteCity.dat.gz > GeoLiteCity.dat.tmp && mv -f GeoLiteCity.dat.tmp GeoLiteCity.dat
    - cwd:  /usr/share/GeoIP
    - require:
      - pkg: geoip
  file.symlink:
    - name:   /usr/share/GeoIP/GeoIPCity.dat
    - target: /usr/share/GeoIP/GeoLiteCity.dat
    - force:  True
    - require:
      - cmd: geoip.city
  cron.present:
    - name:       cd /usr/share/GeoIP && wget -N -nv http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && gzip -d -c GeoLiteCity.dat.gz > GeoLiteCity.dat.tmp && mv -f GeoLiteCity.dat.tmp GeoLiteCity.dat
    - identifier: GEOIP-CITY-UPDATE
    - user:       root
    - dayweek:    4
    - hour:       12
    - minute:     0
    - require:
      - pkg: geoip
