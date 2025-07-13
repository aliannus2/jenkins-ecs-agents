# Makefile for Terraform project with environment support and matching backend

# Environment variables (default values)
TF_WORKSPACE_KEY_PREFIX = ecs
WORKSPACE_NAME = project-jenkins-agents
AWS_REGION = us-east-1
AWS_PROFILE = project-devops
AWS_DYNAMODB_TABLE = project-devops-terraform.lock
AWS_S3_BUCKET = project-devops-us-east-1-terraform-states
ENV_NAME = project-devops

# Target to clean up local Terraform state
terraform-clean:
	@if [ -d ".terraform" ]; then rm -rf .terraform; fi
	@if [ -f "terraform.tfstate" ]; then rm -f terraform.tfstate; fi
	@if [ -d "terraform.tfstate.d" ]; then rm -rf terraform.tfstate.d; fi

init: terraform-clean
	terraform init -backend-config="bucket=$(AWS_S3_BUCKET)" -backend-config="key=us-east-1/ecs/project-jenkins-agents/terraform.tfstate" -backend-config="dynamodb_table=$(AWS_DYNAMODB_TABLE)" -backend-config="region=$(AWS_REGION)" -backend-config="encrypt=true"
	-terraform workspace new $(ENV_NAME)
	terraform workspace select $(ENV_NAME)

show: init
	terraform show \
		-var-file=./$(AWS_REGION)/$(ENV_NAME)/terraform.tfvars \
		-var 'aws_profile=$(AWS_PROFILE)' \
		-var 'aws_region=$(AWS_REGION)'

plan: init
	terraform plan \
		-var-file=./$(AWS_REGION)/$(ENV_NAME)/terraform.tfvars \
		-var 'aws_profile=$(AWS_PROFILE)' \
		-var 'aws_region=$(AWS_REGION)'

apply: init
	terraform apply -auto-approve \
		-var-file=./$(AWS_REGION)/$(ENV_NAME)/terraform.tfvars \
		-var 'aws_profile=$(AWS_PROFILE)' \
		-var 'aws_region=$(AWS_REGION)'

destroy: init
	terraform destroy \
		-var-file=./$(AWS_REGION)/$(ENV_NAME)/terraform.tfvars \
		-var 'aws_profile=$(AWS_PROFILE)' \
		-var 'aws_region=$(AWS_REGION)'

validate:
	terraform validate

fmt:
	terraform fmt -recursive

lint:
	tflint

output:
	terraform output

docs:
	terraform-docs markdown table --output-file README.md --output-mode inject .
