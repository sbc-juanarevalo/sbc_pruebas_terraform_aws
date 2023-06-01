provider "aws" {
    region = "us-east-1"
}

module "lambda_function_existing_package_local" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "Lambda_Practica_Lab1"
  description   = "Descripcion laboratorio lambda"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  create_package         = false
  local_existing_package = "enviarCotizacion.zip"
}