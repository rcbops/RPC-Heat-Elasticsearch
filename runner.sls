saltutil.refresh_pillar:
  salt.function:
    - 'tgt': '*'

mine.update:
  salt.function:
    - tgt: '*'
    - require:
      - salt: saltutil.refresh_pillar

deploy:
  salt.state:
    - tgt: 'G@roles:elasticsearch-client or G@roles:elasticsearch-master or G@roles:elasticsearch-data'
    - tgt_type: compound
    - highstate: True
    - require:
      - salt: mine.update

hardening:
  salt.state:
    - tgt: 'G@roles:elasticsearch-client or G@roles:elasticsearch-master or G@roles:elasticsearch-data'
    - tgt_type: compound
    - sls:
      - elasticsearch.hardening
    - require:
      - salt: deploy
