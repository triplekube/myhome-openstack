
# プロバイダーのバージョンはenvironments/{env}/instace/main.tf で指定します。
terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
    }
  }
}

# 固定IP用のポートを作成します。
resource "openstack_networking_port_v2" "port" {
  for_each = var.instance
  name           = "port-${each.key}"
  network_id     = data.openstack_networking_network_v2.network.id
  admin_state_up = "true"
  # dns_name     = "${each.key}"                       # 作成時に有効だと作成失敗しますが、作成後はこれで変更できます。
  fixed_ip {
    subnet_id = data.openstack_networking_subnet_v2.subnet.id
    ip_address = each.value.ipadr                         # インスタンスに割り当てるIPv4アドレスを指定します
  }
  dynamic allowed_address_pairs {
    for_each = each.value.allowed_address
      content {
        ip_address = try(allowed_address_pairs.value.allow_ipadr, [])
      }
  }
  port_security_enabled = each.value.portsecurity         # MetalLBなど別のIP/MACを割り当てる場合はfalseにしてください
}

# ボリューム作成用に volume_size  = "1" 以上のものだけのリストを作成します。
locals {
  instance = { for k, v in var.instance : k => v if v.volume_size != "0" }
}
output "debug" {
  value = local.instance
  description = "Output for debugging"
}

# ボリュームの作成をします。ポート作成後にボリュームを作成するのはVMがポートを認識できるようにするための時間稼ぎです。
resource "openstack_blockstorage_volume_v3" "volume" {
  # ループは var.instance ではなく フィルタ後のローカル変数 local.instance を使います。
  for_each = local.instance
  region      = each.value.region
  name        = "volume-${each.key}"
  size        = each.value.volume_size
  volume_type = "nfs"
  image_id    = data.openstack_images_image_v2.image[each.key].id
  depends_on = [openstack_networking_port_v2.port]
}

resource "openstack_compute_instance_v2" "instance" {
  for_each = var.instance
  name         = "${each.key}"
  image_name   = each.value.image
  flavor_name  = each.value.flavor
  region       = each.value.region
  key_pair     = each.value.key
  config_drive = each.value.config_drive
  network {
    name = var.user_network
    port = openstack_networking_port_v2.port[each.key].id #portを指定します。port-hogeとせずeach.keyで指定できます。
  }
  dynamic "block_device" {
    # volume_sizeが0以外ならボリュームが作成済みなので、それを指定します。
    for_each = each.value.volume_size != "0" ? [1] : []
    content {
      uuid                  = openstack_blockstorage_volume_v3.volume[each.key].id
      source_type           = "volume"
      destination_type      = "volume"
      boot_index            = 0
      delete_on_termination = true
    }
  }
  user_data  = data.template_file.userdata[each.key].rendered
  depends_on = [openstack_blockstorage_volume_v3.volume]
}
