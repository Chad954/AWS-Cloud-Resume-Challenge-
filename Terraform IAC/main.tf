terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_s3_bucket_website_configuration" "portfolioS3" {
    bucket                = "chadportfoliowebsite1"
    expected_bucket_owner = "536583961527"
    index_document {
        suffix = "index.html"
    }
}

resource "aws_cloudfront_distribution" "cloudfrontPortfolio" {
    aliases                        = [
        "chadcaseportfolio.link",
    ]
    
    default_root_object            = "index.html"
    enabled                        = true
    http_version                   = "http2"    
    is_ipv6_enabled                = true  
    price_class                    = "PriceClass_100"
    retain_on_delete               = false   
    tags                           = {}
    tags_all                       = {}
    wait_for_deployment            = true
    
    default_cache_behavior {
        allowed_methods        = [
            "GET",
            "HEAD",
        ]
        cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
        cached_methods         = [
            "GET",
            "HEAD",
        ]
        compress               = true
        default_ttl            = 0
        max_ttl                = 0
        min_ttl                = 0
        smooth_streaming       = false
        target_origin_id       = "chadportfoliowebsite1.s3.us-east-1.amazonaws.com"
        trusted_key_groups     = []
        trusted_signers        = []
        viewer_protocol_policy = "redirect-to-https"
    }

    origin {
        connection_attempts = 3
        connection_timeout  = 10
        domain_name         = "chadportfoliowebsite1.s3.us-east-1.amazonaws.com"
        origin_id           = "chadportfoliowebsite1.s3.us-east-1.amazonaws.com"
    }

    restrictions {
        geo_restriction {
            locations        = []
            restriction_type = "none"
        }
    }

    viewer_certificate {
        acm_certificate_arn            = "arn:aws:acm:us-east-1:536583961527:certificate/6ba5c982-c7da-45ec-a20e-7f69b2de042e"
        cloudfront_default_certificate = false
        minimum_protocol_version       = "TLSv1.2_2021"
        ssl_support_method             = "sni-only"
    } 
}

resource "aws_route53_zone" "portfolioZoneDNS" {  
    comment      = "HostedZone created by Route53 Registrar"   
    name         = "chadcaseportfolio.link"    
    tags         = {}
    tags_all     = {}
}

resource "aws_dynamodb_table" "portfolioDB" {    
    billing_mode   = "PROVISIONED"
    hash_key       = "record_id"    
    name           = "cloud_resume_counter"
    read_capacity  = 1
    stream_enabled = false
    tags           = {}
    tags_all       = {}
    write_capacity = 1

    attribute {
        name = "record_id"
        type = "S"
    }

    point_in_time_recovery {
        enabled = false
    }
    
    timeouts {}
}

resource "aws_api_gateway_rest_api" "portfolioAPI" {
    api_key_source               = "HEADER"
    binary_media_types           = []
    disable_execute_api_endpoint = false   
    minimum_compression_size     = -1
    name                         = "records"
    put_rest_api_mode            = "overwrite"
    tags                         = {}
    tags_all                     = {}
    endpoint_configuration {
        types            = [
            "REGIONAL",
        ]
    
    }
}


resource "aws_lambda_function" "portfolioLambda1" {
    architectures                  = [
        "x86_64",
    ]
    
    function_name                  = "lambda1"
    handler                        = "lambda_function.lambda_handler"   
    layers                         = []
    memory_size                    = 128
    package_type                   = "Zip"   
    reserved_concurrent_executions = -1
    role                           = "arn:aws:iam::536583961527:role/service-role/lambda1-role-0ot6pnzm"
    runtime                        = "python3.9"
    source_code_hash               = "R7N4z4RWG+KjOjKHyRIOQb4ustDcOQDIWOkLLESTDNU="    
    tags                           = {}
    tags_all                       = {}
    timeout                        = 3
   
    ephemeral_storage {
        size = 512
    }
    
    timeouts {}
    
    tracing_config {
        mode = "PassThrough"
    }
}

resource "aws_lambda_function" "portfolioLambda2" {
    architectures                  = [
        "x86_64",
    ]
    
    function_name                  = "lambda2"
    handler                        = "lambda_function.lambda_handler" 
    layers                         = []
    memory_size                    = 128
    package_type                   = "Zip" 
    reserved_concurrent_executions = -1
    role                           = "arn:aws:iam::536583961527:role/service-role/lambda1-role-0ot6pnzm"
    runtime                        = "python3.9"
    source_code_hash               = "G3d3yrYrM6l6oX4bVo7XXPM+etxu/GXe+Y62sx5hP5w="
    tags                           = {}
    tags_all                       = {}
    timeout                        = 3

    ephemeral_storage {
        size = 512
    }

    timeouts {}

    tracing_config {
        mode = "PassThrough"
    }
}

resource "github_repository" "portfolioGithub" {
  name        = "Backend-Terraform"
  description = "AWS Cloud Resume Challenge IAC Backend"
  visibility = "public"
}
