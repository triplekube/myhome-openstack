terraform {
  backend "s3" {
    bucket = "tfstate.nucos.example.com"
    region = "ap-northeast-1"
    key    = "test/instance/terraform.tfstate"
    endpoint = "https://pipi01.example.com:9000"
    access_key = "minio"
    secret_key = "minio123"
    skip_credentials_validation = true #STS認証の場合false。平文の場合true。
    skip_metadata_api_check = true #EC2 Metadata API. trueならチェックしない。
    force_path_style = true # true なら https://<HOST>/<BUCKET> とする。
  }
}

terraform {
  required_version = "~> 1.5.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.52.0"
    }
  }
}

# 認証情報を記述します。
# ここで指定したユーザーのネットワークにインスタンスが作成されます。
provider "openstack" {
  region      = "ap-northeast-1"
  tenant_name = "taira-project"
  user_name   = "taira"
  password    = "taira1234"
  auth_url    = "http://nucos01.example.com:5000/v3/"
}

# モジュールを呼び出します。
module "instance" {
  source       = "../../../modules/instance/"
  user_network = var.openstack_user_network
  user_subnet  = var.openstack_user_subnet
  instance     = var.openstack_instance
}
