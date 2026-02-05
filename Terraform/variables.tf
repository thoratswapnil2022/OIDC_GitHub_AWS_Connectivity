variable ami {
  description = "The AMI to use for the instance"
  default     = "ami-0df647611daaf315d"
}

variable instance_type {
  description = "The type of instance to use"
  default     = "t2.micro"
}
