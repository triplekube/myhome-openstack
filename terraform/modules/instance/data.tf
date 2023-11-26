data "openstack_networking_network_v2" "network" {
  name = var.user_network
}

data "openstack_networking_subnet_v2" "subnet" {
  name = var.user_subnet
}

data "openstack_images_image_v2" "image" {
  for_each = var.instance
  name = each.value.image
}

data "template_file" "userdata" {
  for_each = var.instance
  template = file("./assets/${each.value.assets_name}.tpl")
  vars = {
    hostname = "${each.key}"
  }
}