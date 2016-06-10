base:

  'roles:elasticsearch-data':
    - match: grain
    - elasticsearch

  'roles:elasticsearch-client':
    - match: grain
    - elasticsearch

  'roles:elasticsearch-master':
    - match: grain
    - elasticsearch
