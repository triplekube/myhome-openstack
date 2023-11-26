
# 実行方法
```
git clone https://hoge/rpi-openstack
cd rpi-openstack/terraform
terraform init
terraform plan
terraform apply
```

# フォルダ構成
```
terraform
├── .terraform-version     # terraformのバージョンを固定しています。
└── os-instance/           # インスタンスを作成するためのtfです。
    ├── main.tf
    ├── terraform.tfvars
    └── assets/                     # インスタンスのcloud-initで使用するファイルです。
        ├── default.tpl             # 基本的なcloud-initを記述しています。
        ├── k8s-kubeadm-control.tpl # kubeadmクラスターのcloud-initです。
        ├── k8s-kubeadm-worker.tpl  #
        ├── k8s-image-builder.tpl   # CAPIイメージビルダー用のcloud-initです。
        ├── k8s-capi-control.tpl    # CAPIクラスターのcloud-initです。
        ├── k8s-capi-worker.tpl     #
        └── hoge.tpl                # その他のcloud-initです。
```
