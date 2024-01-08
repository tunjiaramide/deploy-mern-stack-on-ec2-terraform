variable "ami" {
  default = "ami-0c7217cdde317cfec" # Ubuntu 22.04 us=east-1
  type    = string
}


variable "instance_type" {
  default = "t2.micro"
  type    = string
}
