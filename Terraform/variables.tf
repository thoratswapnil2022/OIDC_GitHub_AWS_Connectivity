variable ami {
  description = "The AMI to use for the instance"
  default     = "ami-0c55b159cbfafe1f0"
}

variable instance_type {
  description = "The type of instance to use"
  default     = "t2.micro"
}
