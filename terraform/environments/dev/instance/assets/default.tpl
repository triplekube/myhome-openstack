## template: jinja
#cloud-config
# 追加するユーザー名を指定します。
{% set username = 'taira' %}
timezone: Asia/Tokyo
package_update: true
package_upgrade: true
keyboard:
  layout: jp
packages:
  - zip
  - avahi-daemon
  - avahi-utils
  - apt-transport-https
  - ca-certificates
  - curl
  - gnupg
  - lsb-release
  - prometheus-node-exporter
write_files:
  - path: /etc/systemd/timesyncd.conf
    content: |
      [Time]
      NTP=ntp.nict.jp
      FallbackNTP=ntp.ubuntu.com
users:
  - name: {{ username }}
    shell: /bin/bash
    groups: adm,admin
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
#コンソールログインを有効にするためmkpasswdで作成したパスワードを指定します。
    passwd: $6$YMrhogehohoeohohogehoohge
#コンソールログインを有効にするためpasswdのロックを解除します。
    lock_passwd: false
    ssh_authorized_keys:
      - ssh-rsa AAAAB3Nhohgogehoege== taira@example.com
runcmd:
  - systemctl restart systemd-timesyncd.service
  - systemctl restart avahi-daemon.service
  - systemctl enable prometheus-node-exporter.service
final_message: "The system is finally up, after $UPTIME seconds"