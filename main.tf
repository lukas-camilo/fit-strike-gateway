provider "aws" {
    region = var.region
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

resource "aws_api_gateway_integration" "lambda_integration" {
    rest_api_id = aws_api_gateway_rest_api.fit_strike_api.id
    resource_id = aws_api_gateway_rest_api.fit_strike_api.root_resource_id
    http_method = "ANY"
    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
}