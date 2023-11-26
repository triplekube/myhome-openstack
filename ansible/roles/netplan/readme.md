# これはnetplanの設定をVLAN環境のOpenStack用にするためのplaybookです。

## 概要

ansible-playbook実行時に、インターフェイス名をeth0/eth1に固定します。<BR>
また、eth0は指定されたIPアドレスに固定します。<BR>

RPiやNUCをセットアップすると往々にして初回のIPアドレスはDHCPで取得しますが、運用を開始すると固定IPや固定のインターフェイス名が必要です。<BR>
しかしこれら設定は面倒です。

そのため、これを使って設定します。


## 使い方

### 1 デフォゲとDNSを編集

デフォルトゲートウェイとDNSを編集します。
tasks/main.yamlの先頭にある
 "name: nic0のインターフェイス名やデフォゲを設定します。"
の部分を自分の環境に合うように書き換えてください。

### 2 NIC名を確認する

編集対象のサーバーのNIC名を確認します。サーバーが pios01.local なら<BR>
``ssh pios01.local "ip a|grep BROADCAST"``<BR>
などとすると、RPiなら2が内蔵NIC、3がUSBのNICとして表示されると思います。<BR>
通常2はeth0、3はenxで始まる名前になりますので3の方を覚えておいてください。

### 3 実行する

引数に現在のホスト名やIPアドレスと、変えたいIPアドレス、それとnic1にUSBのNIC名を書いて実行します。

- -i pios01.local や DHCP等で取得した（一時的な）IPアドレス
- yyy.yyy.yyy.yyy/yy = 恒久的に設定したいIPアドレスとサブネットマスク
- nic0 : eth0 (RPiを想定していてそのままなら省略可)
- nic1 : enx000ec6c97fba (2 nic名を確認するで取得したインターフェイス名)

```
ansible-playbook ansible/play-netplan.yml -i host名.local, -e "ip0=yyy.yyy.yyy.yyy/yy nic1=enx000ec6c97fba"
```

### 例（pios04.localと192.168.1.3はNUC等の例です。）
```
ansible-playbook ansible/play-netplan.yml -i pios01.local, -e "ip0=10.234.15.11/22 nic0=eth0 nic1=enx000ec6c97fba"
ansible-playbook ansible/play-netplan.yml -i pios02.local, -e "ip0=10.234.15.12/22 nic0=eth0 nic1=enx000ec6c97fa8"
ansible-playbook ansible/play-netplan.yml -i 192.168.1.3, -e "ip0=10.234.15.11/22 nic0=ens3 nic1=enp1s0"
ansible-playbook ansible/play-netplan.yml -i 10.234.12.188, -e "ip0=10.234.14.11/22 nic0=enp1s0 nic1=enx207bd27657eb"
ansible-playbook ansible/play-netplan.yml -i 10.234.13.23, -e "ip0=10.234.14.12/22 nic0=enp2s0 nic1=enx207bd2758d90"
ansible-playbook ansible/play-netplan.yml -i 10.234.12.207, -e "ip0=10.234.14.21/22 nic0=enp0s31f6 nic1=enx207bd2754b04"
```

### それ以外の例

NUCやPC、または追加するNICのメーカーやバージョン違いで、内蔵NICのインターフェイス名も異なる場合があります。<BR>
その場合、変更前のインターフェイス名を指定してください。

- nic0 : hoge (省略時は eth0 で、他に ens3 や enp0s1 などがあります）。
- nic1 : fuga (省略時は enx となります。)

``````
ansible-playbook play-netplan.yml -i xxx.xxx.xxx.xxx, -e "ip0=yyy.yyy.yyy.yyy/yy nic0=hoge nic1=fuga"
``````

### その他

NUCなどはsudoの設定が必要です。以下のように設定してから作業します。
sudo -i
echo "taira ALL=(ALL) NOPASSWD:ALL" |sudo tee -a /etc/sudoers.d/taira_sudoers
