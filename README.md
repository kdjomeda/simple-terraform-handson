#Simple Terraform AWS Infra

## Task 1

- Create an AWS Account
- Create an AWS IAM Account
  - IAM > Users > Add user
  - Input the username in the field
  - check on programmatic access only
  - Click on Next: Permissions
  - Click on Tab: Attach Existing policies directly
    - EC2FullAccess
    - RDSFullAccess
    - S3FullAccess
   - Next: Tags
   - Next: Review
   - Next: Create User
   
   
 ## Task 2 (Optional)
 
 - Install AWScli using python pip
 - Configure awscli with command: aws configure
   - Enter access key
   - Enter access secret
   - Enter default region: us-east-1
   - use default till the end
   
## Task 3 

- Create a _main.tf file 
- Configure aws provider and optionally aws profile if task2 was completed
   ```$hcl
   provider "aws" {
     region = "us-east-1"
     profile = "<name_of_your_profile>" # Only when using awscli 
   }
   ```
 - Configure system|IDE environment variable with:
   ```$xslt
     export AWS_ACCESS_KEY_ID=(your access key id)
     export AWS_SECRET_ACCESS_KEY=(your secret access key)
   ```
  