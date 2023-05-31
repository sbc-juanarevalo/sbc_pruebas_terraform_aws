variable "function_name" {
  description = "The name of the Lambda function"
}

variable "tags" {
  description = "The tags of the Lambda function"
}

variable "timeout" {
  description = "The tags of the Lambda function"
  default     = 25
}

// Aprovisiona el rol que usará la lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

// Aprovisiona la lambda
resource "aws_lambda_function" "lambda" {
  function_name = "${var.function_name}-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  #filename      = "${path.module}/lambda_function.zip"
  timeout       = var.timeout

  environment {
    variables = {
      ENVIROMENT = var.tags.enviroment
    }
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_policy" "function_log_group_policy" {
  name = "${var.function_name}-lambda-loggroup-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["logs:*"]
        Resource = [
          "${aws_cloudwatch_log_group.function_log_group.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "function_log_group_lambda" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.function_log_group_policy.arn
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "function_lambda" {
  value = aws_lambda_function.lambda
}

output "function_role" {
  value = aws_iam_role.lambda_role
}


# // Aprovisiona el recurso
# resource "aws_api_gateway_resource" "lambda_resource" {
#   rest_api_id = var.api_gateway.id
#   parent_id   = var.api_gateway.root_resource_id
#   path_part   = "${var.function_name}-${var.api_gateway_path}"
# }

# // Aprovisiona el Metodo de consumo
# resource "aws_api_gateway_method" "lambda_method" {
#   rest_api_id   = var.api_gateway.id
#   resource_id   = aws_api_gateway_resource.lambda_resource.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# // Aprovisiona la integración
# resource "aws_api_gateway_integration" "lambda_integration" {
#   rest_api_id             = var.api_gateway.id
#   resource_id             = aws_api_gateway_resource.lambda_resource.id
#   http_method             = aws_api_gateway_method.lambda_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.lambda.invoke_arn
# }

# // Aprvisiona los permisos
# resource "aws_lambda_permission" "apigw_permissions" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.lambda.function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${var.api_gateway.execution_arn}/*/*"
# }

# // Aprovisiona el deployment
# resource "aws_api_gateway_deployment" "integration_deployment" {
#   rest_api_id = var.api_gateway.id
#   depends_on  = [aws_api_gateway_integration.lambda_integration]
#   stage_name  = var.tags.enviroment
# }
