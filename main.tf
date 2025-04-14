provider "aws" {
    region = var.region
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket  = "terraform-state-bucket-lucas"
    key     = "terraform-fit-strike.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

resource "aws_api_gateway_rest_api" "fit_strike_api" {
    name = "Fit Strike API"
    description = "API Gateway for Fit Strike APP"
    body = file("${path.module}/openapi.yaml")
}

resource "aws_api_gateway_deployment" "api_deployment" {
    rest_api_id = aws_api_gateway_rest_api.fit_strike_api.id
    stage_name = "prod"
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
    name = "CognitoAuthorizer"
    rest_api_id = aws_api_gateway_rest_api.fit_strike_api.id
    identity_source = "method.request.header.Authorization"
    provider_arns = [var.cognito_pool_arn]
    type = "COGNITO_USER_POOLS"
}