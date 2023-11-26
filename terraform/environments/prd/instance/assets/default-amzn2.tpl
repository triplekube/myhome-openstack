#cloud-config
timezone: Asia/Tokyo
keyboard:
  layout: jp
users:
  - name: taira
    groups: [ adm,wheel,systemd-journal ]
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    passwd: $6$YMrhogehohoeohohogehoohge
    lock_passwd: false
    ssh_authorized_keys:
      - ssh-rsa AAAAB3Nhohgogehoege== taira@example.com
