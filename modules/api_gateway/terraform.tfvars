api_name                            = "test"
api_authorizer_lambda               = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:829968223664:function:test/invocations"
api_endpoint_type                   = "REGIONAL"
api_authorizer_type                 = "REQUEST"
api_authorizer_type_identity_source = "method.request.header.Authorization"
