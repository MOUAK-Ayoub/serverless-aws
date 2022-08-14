variable "python_script" {

  
  
  
}


variable "role_lambda" {

    default = {
    rolename = "role_for_lambda"
    policyname = "policy_for_lambda"
    policypath="../policy/lambda_policy.json"
   
  }
  
}
