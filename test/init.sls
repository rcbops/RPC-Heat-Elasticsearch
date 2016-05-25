/root/test.sh:
  file.managed:
    - source: salt://elasticsearch/test/files/test.sh.jinja2
    - template: jinja

bash /root/test.sh:
  cmd.run:
    - require:
      - file: /root/test.sh
