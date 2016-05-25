base:

  'roles:elasticsearch-client':
    - match: grain
    - elasticsearch.elasticsearch

  'roles:elasticsearch-master':
    - match: grain
    - elasticsearch.elasticsearch

  'roles:elasticsearch-data':
    - match: grain
    - elasticsearch.elasticsearch
