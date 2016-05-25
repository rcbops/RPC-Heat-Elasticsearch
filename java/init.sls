python-software-properties:
  pkg.installed:
    - require_in:
      - pkgrepo: webupd8team/java

webupd8team/java:
  pkgrepo.managed:
    - ppa: webupd8team/java
    - require_in:
      - pkg: oracle-java7-installer

debconf-oracle-select:
  debconf.set:
    - name: oracle-java7-installer
    - data:
        shared/accepted-oracle-license-v1-1:
          type: boolean
          value: true
    - require_in:
      - pkg: oracle-java7-installer

oracle-java7-installer:
  pkg.installed
