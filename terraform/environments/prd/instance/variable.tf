# 全インスタンス共通のネットワークを指定します。
variable "openstack_user_network" {
  default = "taira-network"
}

# 全インスタンス共通のサブネットを指定します。
variable "openstack_user_subnet" {
  default = "taira-subnet"
}

# インスタンスを指定します。each.key がインスタンス名になります。
# cinderがない場合、volume_sizeは0を指定してください。
variable "openstack_instance" {
  default = {
    simple-prd = {
      assets_name  = "default"
      image        = "ubuntu-22.04-arm64" # bootするイメージを指定します。
      portsecurity = true                 # MetalLBなど別のIP/MACを割り当てる場合はfalseにしてください。
      ipadr        = "192.168.0.70"
      float        = ""
      flavor       = "micro"
      volume_size  = "0"                  # Cinderブートボリュームを作成しない場合は0を指定し、作成する場合は1(GB)以上を指定します。
      key          = "taira-pub"
      region       = "ap-northeast-1"
      config_drive = false                # amzn2の場合はtrueにしてください。
      allowed_address = []
    },
  }
}


