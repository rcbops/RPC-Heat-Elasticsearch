{% from 'elasticsearch/elasticsearch/elasticsearch.jinja' import elasticsearch with context %}
include:
  - elasticsearch.java

{% if elasticsearch.apt_pkgs %}
install_apt_pkgs:
  pkg.installed:
    - pkgs:
{% for apt_pkg in elasticsearch.apt_pkgs %}
      - {{ apt_pkg }}
{% endfor %}
{% endif %}

elasticsearch_group:
  group.present:
    - name: {{ elasticsearch.group }}

elasticsearch_user:
  user.present:
    - name: {{ elasticsearch.user }}
    - groups:
      - {{ elasticsearch.group }}
    - require:
      - group: elasticsearch_group

# Download deb
/tmp/elasticsearch-{{ elasticsearch.version }}.deb:
  file.managed:
    - source: {{ elasticsearch.download_url }}/elasticsearch-{{ elasticsearch.version }}.deb
    - source_hash: md5={{ elasticsearch.md5 }}
    - mode: 0440
    - unless: [ -e /usr/share/elasticsearch/lib/elasticsearch-{{ elasticsearch.version }}.jar ]

remove_previous:
  cmd.wait:
    - name: dpkg --remove elasticsearch
    - unless: [ -e /usr/share/elasticsearch/lib/elasticsearch-{{ elasticsearch.version }}.jar ]

install:
  cmd.run:
    - name: dpkg -i -E --force-confnew /tmp/elasticsearch-{{ elasticsearch.version }}.deb
    - require:
      - cmd: remove_previous
    - unless: [ -e /usr/share/elasticsearch/lib/elasticsearch-{{ elasticsearch.version }}.jar ]

  file.directory:
    - name: /usr/share/elasticsearch
    - owner: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - recurse:
      - user
      - group
      - mode
    - require:
      - user: elasticsearch_user

{% for dir in elasticsearch.dirs %}
{{ dir }}:
  file.directory:
    - owner: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - recurse:
      - user
      - group
      - mode
    - require:
      - user: elasticsearch_user
{% endfor %}

/etc/security/limits.d/elasticsearch.conf:
  file.managed:
  - source: salt://elasticsearch/elasticsearch/files/limits.conf.jinja2
  - owner: root
  - mode: 0600
  - watch_in:
    - service: elasticsearch

limits-/etc/pam.d/su:
  file.append:
    - name: /etc/pam.d/su
    - text: 'session    required   pam_limits.so'
    - watch_in:
      - service: elasticsearch

limits-/etc/pam.d/common-session:
  file.append:
    - name: /etc/pam.d/common-session
    - text: 'session    required   pam_limits.so'
    - watch_in:
      - service: elasticsearch

limits-/etc/pam.d/common-session-noninteractive:
  file.append:
    - name: /etc/pam.d/common-session-noninteractive
    - text: 'session    required   pam_limits.so'
    - watch_in:
      - service: elasticsearch

limits-/etc/pam.d/sudo:
  file.append:
    - name: /etc/pam.d/sudo
    - text: 'session    required   pam_limits.so'
    - watch_in:
      - service: elasticsearch

# Make sure max file limits is set for elastic search service init script
# TODO
# - lineinfile: dest=/etc/init.d/elasticsearch regexp='^(DAEMON_OPTS=".*-Des.max-open-files=true")$' insertafter='^(DAEMON_OPTS=".*CONF_DIR")$' line='DAEMON_OPTS="$DAEMON_OPTS -Des.max-open-files=true"'

# @TODO plugins

{{ elasticsearch.conf_dir }}/elasticsearch.yml:
  file.managed:
    - source: salt://elasticsearch/elasticsearch/files/elasticsearch.yml.jinja2
    - template: jinja
    - owner: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - mode: 0644
    - watch_in:
      - service: elasticsearch
    - require:
      - user: elasticsearch_user

/etc/default/elasticsearch:
  file.managed:
    - source: salt://elasticsearch/elasticsearch/files/elasticsearch.default.jinja2
    - template: jinja
    - owner: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - watch_in:
      - service: elasticsearch
    - require:
      - user: elasticsearch_user

elasticsearch:
  service.running:
    - name: elasticsearch
    - enable: True
