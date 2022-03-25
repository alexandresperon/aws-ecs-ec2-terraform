variable "name" {
  description = "The name of the profile"
  default     = "default"
}

variable "policy_arn" {
  description = "Policy ARN to be attached to the role"
  default     = ""
}
