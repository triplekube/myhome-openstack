
# 実行方法
```
git clone https://github.com/triplekube/myhome-openstack
cd myhome-openstack
ansible-playbook ansible/play-netplan.yml -i 10.234.12.188, -e "ip0=10.234.14.11/22 nic0=enp1s0 nic1=enx207bd27657eb"
ansible-playbook ansible/site.yml -i ansible/inventories/dev/hosts.yml --check
ansible-playbook ansible/site.yml -i ansible/inventories/nucos/hosts.yml --check

```

# フォルダ構成
```
ansible
├── play-netplan.yml          # netplanの設定を行います。
├── site.yml                  # openstackのインストールを行います。
├── inventories/              # 接続先のホストを記述します。
│   ├── dev/                  # DEVはRPiのOpenStackだけで構成されたDEV環境です。
│   │   ├── hosts.yml
│   │   └── group_vars/
│   │       └── all.yml
│   └── prd/                  # PRDはRPi(ARM)/NUC(Intel)混成で構成され、本番として利用しています。
│       ├── hosts.yml
│       └── group_vars/
│           └── all.yml
├── roles/
│   ├── openstack/
│   │   ├── tasks/            # 具体的な実行タスクが記述されます。
│   │   │   ├── main.yml      # このファイルで各タスクをincludeしています。不要なタスクは削除してください。
│   │   │   ├── hoge1.yaml
│   │   │   └── hoge2.yaml
│   │   ├── handlers/         # アプリを再起動するeventやstateに応答するために使用されます。
│   │   │   └── main.yml
│   │   ├── files/            # 編集されずにそのままコピーされる静的ファイルはこちらに格納します。
│   │   ├── templates/        # jinjaテンプレートで書き換えが必要な動的ファイルはこちらに格納します。
│   ├── common/
│   └── netplan/
└── ansible.cfg               # sshの設定などを記述します。
```
