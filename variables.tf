variable region {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

variable lambda_function_arn {
  type        = string
  default     = "arn:aws:lambda:us-east-1:911167911476:function:fit-strike-api"
  description = "Fit strike ARN"
}

variable cognito_pool_arn {
  type        = string
  default     = "arn:aws:cognito-idp:us-east-1:911167911476:userpool/us-east-1_UdaK4jaHL"
  description = "Cognito pool ARN"
}