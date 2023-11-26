# 全インスタンス共通のネットワークを指定します。
variable "openstack_user_network" {
  default = "taira-network"
}

# 全インスタンス共通のサブネットを指定します。
variable "openstack_user_subnet" {
  default = "taira-subnet"
}

# インスタンスを指定します。each.key がインスタンス名になります。
variable "openstack_instance" {
  default = {

  ## Ubuntuでの最小構成のインスタンス例となります。portsecurityはデフォルトで有効で、
  ## 自分以外のIP/MACが割り当てられないようになっているので安全性が向上します。
  ## volume_sizeは0を指定するとローカルディスクで起動します。
  ## 容量はフレーバーの指定サイズとなります。keyはsshキーの名前を指定します。

    simple = {
      assets_name  = "default"
      image        = "ubuntu-22.04-arm64" # bootするイメージを指定します。
      portsecurity = true                 # MetalLBなど別のIP/MACを割り当てる場合はfalseにしてください。
      ipadr        = "192.168.4.11"
      float        = ""
      flavor       = "micro"
      volume_size  = "0"                  # Cinderブートボリュームを作成しない場合は0を指定し、作成する場合は1(GB)以上を指定します。
      key          = "taira-pub"
      region       = "ap-northeast-1"
      config_drive = false                # amzn2の場合はtrueにしてください。
      allowed_address = []
    },

  ## simpleのディスクをCinderブートボリュームに変更したもので、
  ## volume_sizeを1以上にするとCinderブートボリュームを作成します。
  ## もしCinderをインストールしていない場合は0を指定してください。

    simple-nfs = {
      assets_name  = "default"
      image        = "ubuntu-22.04-arm64"
      portsecurity = true
      ipadr        = "192.168.4.12"
      float        = ""
      flavor       = "micro"
      volume_size  = "20"
      key          = "taira-pub"
      region       = "ap-northeast-1"
      config_drive = false
      allowed_address = []
    },

  ## Amazon Linux 2を起動する場合は以下のように指定します。
  ## config_driveがseed.isoの役目をするのでこれを有効にするのが他OSとの相違点です。

  ## 注意：computeノードがarmの場合config_driveがうまく動いていません。amd64のノードをご利用ください。

    # amzn-test = {
    #   assets_name  = "default-amzn2"
    #   image        = "amzn2-2.0.20231101.0-arm64"
    #   portsecurity = true
    #   ipadr        = "192.168.4.13"
    #   float        = ""
    #   flavor       = "micro"
    #   volume_size  = "30"
    #   key          = "taira-pub"
    #   region       = "ap-northeast-1"
    #   config_drive = true                         # amzn2の場合はtrueにしてください。
    #   allowed_address = []
    # },

  }
}

