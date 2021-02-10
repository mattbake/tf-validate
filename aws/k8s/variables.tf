variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "worker1_instance_type" {
  default     = "t2.small"
  description = "Instance types for worker group 1"
}

variable "worker1_desired_capacity" {
  default     = 2
  description = "Instance types for worker group 1"
}

variable "worker2_instance_type" {
  default     = "t2.medium"
  description = "Instance types for worker group 2"
}

variable "worker2_desired_capacity" {
  default     = 3
  description = "Instance types for worker group 1"
}
