#!/usr/bin/env python

def lambda_handler(event, context):
  return {
    "isBase64Encoded": False,
    "statusCode": 200,
    "headers": { "TestHeader": "test"},
    "body": "OK"
  }