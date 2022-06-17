variable "token" {
  description = "Yandex Cloud OAuth token"
  default     = "token" #use terraform.tfvars to set variables
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID where resources will be created"
  default     = "folder_id"
}

variable "cloud_id" {
  description = "Yandex Cloud ID where resources will be created"
  default     = "cloud_id"
}

variable "zone_id" {
  description = "Yandex Cloud Zone ID where resources will be located"
  default     = "ru-central1-b"
}