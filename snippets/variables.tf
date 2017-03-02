variable "region" {
  default = "eu-west-2"
}

##### Redis
variable "cache-node-size" {
  default = "cache.m3.large"
}

variable "cache-port" {
  default = "6379"
}

variable "cache-num-nodes" {
  default = "1"
}

variable "cache-param-group" {
  default = "default.redis3.2"
}
