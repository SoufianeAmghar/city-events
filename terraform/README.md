# city-events
This project is an Infrastructure-as-Code (IaC) implementation using Terraform to deploy a serverless architecture on AWS. It includes the following components:

- **AWS Lambda**: Serverless functions that handle business logic.
- **AWS DynamoDB**: A NoSQL database for storing application data.
- **AWS S3**: A storage service for static assets and data.

## Project Structure
The project is organized into modules and environments:

- **modules/**: Contains reusable Terraform modules for different AWS services.
  - **lambda/**: Module for AWS Lambda functions.
  - **dynamodb/**: Module for AWS DynamoDB tables.
  - **s3/**: Module for AWS S3 buckets.

- **environments/**: Contains environment-specific configurations.
  - **dev/**: Development environment configuration.
  - **prod/**: Production environment configuration.

## Setup Instructions
1. **Install Terraform**: Ensure you have Terraform installed on your machine. You can download it from [terraform.io](https://www.terraform.io/downloads.html).

2. **Configure AWS Credentials**: Set up your AWS credentials using the AWS CLI or by configuring the `~/.aws/credentials` file.

3. **Initialize Terraform**: Navigate to the desired environment directory (e.g., `environments/dev`) and run:
   ```
   terraform init
   ```

4. **Plan the Deployment**: To see what resources will be created, run:
   ```
   terraform plan
   ```

5. **Apply the Configuration**: To create the resources, run:
   ```
   terraform apply
   ```

6. **Outputs**: After applying, you can view the outputs defined in the respective `outputs.tf` files to get information about the created resources.

## Additional Information
- Ensure that you have the necessary permissions in your AWS account to create the resources defined in the modules.
- Modify the `variables.tf` files in the respective environment directories to customize the configuration for your needs.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.