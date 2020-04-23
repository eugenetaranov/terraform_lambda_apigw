function_name        = "test"
function_handler     = "test.lambda_handler"
function_source_file = "test.py"
function_memory      = 128
function_runtime     = "python3.8"
function_timeout     = 30
function_description = "test func"
//function_iam_role    = ""
log_retention_perion = 1
function_environment = {
  "variables" : {
    "TEST" : "TEST"
  }
}