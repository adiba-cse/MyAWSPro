variable "secingressrule" {
  type = map(string)
}


variable "amiinst" {
  type        = string
  default     = "ami-084568db4383264d4"
  description = "this is our ami id"
}


variable "inst_type" {
  type        = string
  default     = "t2.micro"
  description = "this is our instance type"
}
variable "inst_count" {
  type    = number
  default = 1
}


variable "itisourlistvar" {
  type    = list(string)
  default = ["Tag1", "Tag2", "Tag3"]
}

variable "setprac" {
  type    = set(string)
  default = ["a", "a", "b", "c"]
}