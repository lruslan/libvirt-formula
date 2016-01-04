{% from "libvirt/map.jinja" import map with context %}
include:
  - .install
  - .service

libvirt.listen.service.directory:
  file.directory:
    - name: /etc/systemd/system/{{ map.service }}.service.d
    - group: root
    - user: root
    - mode: 755
    - require:
      - pkg: libvirt.install

libvirt.listen.service.override:
  file.managed:
    - name: /etc/systemd/system/{{ map.service }}.service.d/listen.conf
    - group: root
    - user: root
    - mode: 644
    - require:
      - file: libvirt.listen.service.directory

libvirt.listen.systemctl.daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - file: libvirt.listen.service.override
    - watch:
      - file: libvirt.listen.service.override
    - watch_in:
      - service: libvirt.service