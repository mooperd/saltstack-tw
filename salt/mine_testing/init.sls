/root/saltmine-example2.txt:
  file.managed:
    - source: salt://mine_testing/saltmine-example2.jinja
    - template: jinja

/root/saltmine-example3.txt:
  file.managed:
    - source: salt://mine_testing/saltmine-example3.jinja
    - template: jinja

/root/saltmine-example.txt:
  file.managed:
    - source: salt://mine_testing/saltmine-example.jinja
    - template: jinja
