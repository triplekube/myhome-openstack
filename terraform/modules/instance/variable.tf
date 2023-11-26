variable "user_network" {
  type = string
}

variable "user_subnet" {
  type = string
}

variable "instance" {
  type = map(object({
    assets_name     = string
    image           = string
    portsecurity    = bool
    ipadr           = string
    float           = string
    flavor          = string
    volume_size     = string
    key             = string
    region          = string
    config_drive    = bool
    allowed_address = list(object({
      allow_ipadr = string
    }))
  }))
}
