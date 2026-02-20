terraform { 
  cloud { 
    organization = "greed-island" 

    workspaces { 
      name = "sentinel-x-sentinel" 
    } 
  } 
}

provider "aws" {
  region = var.region
}

# ===============================================================================
# Lambda IAM Role - Required for all Lambda functions
# ===============================================================================

resource "aws_iam_role" "lambda_role" {
  name = "lambda-runtime-test-role"
  
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

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ===============================================================================
# PASS TEST - Current Supported Runtimes (KEEP ACTIVE FOR ALL TESTS)
# ===============================================================================
# These functions use current, supported runtimes and should remain active
# They will be part of PASS, FAIL, and WARNING test mocks

# resource "aws_lambda_function" "python_current" {
#   function_name = "test-python-current"
#   runtime       = "python3.13"
#   handler       = "index.handler"
#   role          = aws_iam_role.lambda_role.arn
#   filename      = "${path.module}/lambda-placeholder.zip"
  
# }

# resource "aws_lambda_function" "nodejs_current" {
#   function_name = "test-nodejs-current"
#   runtime       = "nodejs22.x"
#   handler       = "index.handler"
#   role          = aws_iam_role.lambda_role.arn
#   filename      = "${path.module}/lambda-placeholder.zip"
  
# }

# resource "aws_lambda_function" "java_current" {
#   function_name = "test-java-current"
#   runtime       = "java21"
#   handler       = "com.example.Handler"
#   role          = aws_iam_role.lambda_role.arn
#   filename      = "${path.module}/lambda-placeholder.zip"
  
# }

# resource "aws_lambda_function" "dotnet_current" {
#   function_name = "test-dotnet-current"
#   runtime       = "dotnet8"
#   handler       = "Handler::FunctionHandler"
#   role          = aws_iam_role.lambda_role.arn
#   filename      = "${path.module}/lambda-placeholder.zip"
  
# }

# resource "aws_lambda_function" "ruby_current" {
#   function_name = "test-ruby-current"
#   runtime       = "ruby3.3"
#   handler       = "handler.process"
#   role          = aws_iam_role.lambda_role.arn
#   filename      = "${path.module}/lambda-placeholder.zip"
  
# }

# ===============================================================================
# FAIL TEST - Deprecated Runtimes (UNCOMMENT FOR FAIL TEST ONLY)
# ===============================================================================
# Uncomment all resources below to generate FAIL test mock
# These runtimes are fully deprecated and should cause policy failures

# Node.js deprecated versions
resource "aws_lambda_function" "nodejs" {
  function_name = "test-nodejs"
  runtime       = "nodejs"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "nodejs43" {
  function_name = "test-nodejs43"
  runtime       = "nodejs4.3"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "nodejs43_edge" {
  function_name = "test-nodejs43-edge"
  runtime       = "nodejs4.3-edge"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "nodejs610" {
  function_name = "test-nodejs610"
  runtime       = "nodejs6.10"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "nodejs810" {
  function_name = "test-nodejs810"
  runtime       = "nodejs8.10"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "nodejs10x" {
  function_name = "test-nodejs10x"
  runtime       = "nodejs10.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "nodejs12x" {
  function_name = "test-nodejs12x"
  runtime       = "nodejs12.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "nodejs14x" {
  function_name = "test-nodejs14x"
  runtime       = "nodejs14.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "nodejs16x" {
  function_name = "test-nodejs16x"
  runtime       = "nodejs16.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "nodejs18x" {
  function_name = "test-nodejs18x"
  runtime       = "nodejs18.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

# Python deprecated versions
resource "aws_lambda_function" "python27" {
  function_name = "test-python27"
  runtime       = "python2.7"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "python36" {
  function_name = "test-python36"
  runtime       = "python3.6"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "python37" {
  function_name = "test-python37"
  runtime       = "python3.7"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "python38" {
  function_name = "test-python38"
  runtime       = "python3.8"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "python39" {
  function_name = "test-python39"
  runtime       = "python3.9"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

# .NET deprecated versions
resource "aws_lambda_function" "dotnetcore10" {
  function_name = "test-dotnetcore10"
  runtime       = "dotnetcore1.0"
  handler       = "Handler::FunctionHandler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "dotnetcore20" {
  function_name = "test-dotnetcore20"
  runtime       = "dotnetcore2.0"
  handler       = "Handler::FunctionHandler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "dotnetcore21" {
  function_name = "test-dotnetcore21"
  runtime       = "dotnetcore2.1"
  handler       = "Handler::FunctionHandler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "dotnetcore31" {
  function_name = "test-dotnetcore31"
  runtime       = "dotnetcore3.1"
  handler       = "Handler::FunctionHandler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "dotnet50" {
  function_name = "test-dotnet50"
  runtime       = "dotnet5.0"
  handler       = "Handler::FunctionHandler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "dotnet6" {
  function_name = "test-dotnet6"
  runtime       = "dotnet6"
  handler       = "Handler::FunctionHandler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "dotnet7" {
  function_name = "test-dotnet7"
  runtime       = "dotnet7"
  handler       = "Handler::FunctionHandler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

# Ruby deprecated versions
resource "aws_lambda_function" "ruby25" {
  function_name = "test-ruby25"
  runtime       = "ruby2.5"
  handler       = "handler.process"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

resource "aws_lambda_function" "ruby27" {
  function_name = "test-ruby27"
  runtime       = "ruby2.7"
  handler       = "handler.process"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

# Java deprecated version
resource "aws_lambda_function" "java8" {
  function_name = "test-java8"
  runtime       = "java8"
  handler       = "com.example.Handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

# Go deprecated version
resource "aws_lambda_function" "go1x" {
  function_name = "test-go1x"
  runtime       = "go1.x"
  handler       = "main"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

# Custom runtime deprecated version
resource "aws_lambda_function" "provided" {
  function_name = "test-provided"
  runtime       = "provided"
  handler       = "bootstrap"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda-placeholder.zip"
}

# ===============================================================================
# WARNING TEST - Soon-to-be Deprecated Runtimes (UNCOMMENT FOR WARNING TEST ONLY)
# ===============================================================================
# Uncomment all resources below to generate WARNING test mock
# These runtimes will be deprecated soon and should generate warnings (but pass)

# resource "aws_lambda_function" "ruby32" {
#   function_name = "test-ruby32"
#   runtime       = "ruby3.2"
#   handler       = "handler.process"
#   role          = aws_iam_role.lambda_role.arn
#   filename      = "${path.module}/lambda-placeholder.zip"
# }

# resource "aws_lambda_function" "nodejs20x" {
#   function_name = "test-nodejs20x"
#   runtime       = "nodejs20.x"
#   handler       = "index.handler"
#   role          = aws_iam_role.lambda_role.arn
#   filename      = "${path.module}/lambda-placeholder.zip"
# }

# resource "aws_lambda_function" "provided_al2" {
#   function_name = "test-provided-al2"
#   runtime       = "provided.al2"
#   handler       = "bootstrap"
#   role          = aws_iam_role.lambda_role.arn
#   filename      = "${path.module}/lambda-placeholder.zip"
# }
