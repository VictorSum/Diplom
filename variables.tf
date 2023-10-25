variable "cloud_access_token" {
  type = string
  sensitive = true
}

variable "cloud_access_cloud_id" {
  type = string
  sensitive = true
}

variable "cloud_access_folder_id" {
  type = string
  sensitive = true
}


variable "zone" {
  default = "ru-central1-c"
}

variable "image_id" {
  default = "fd8kkn5n7q1k80m9sncb"
}