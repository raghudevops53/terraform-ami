help:           ## Show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## Terraform init for DEV env
	@terraform init -no-color -backend-config=key=${TF_VAR_COMPONENT}/ami/terraform.tfstate -backend-config=bucket="d53-terraform-state-files" -backend-config=region=us-east-1 -backend-config=dynamodb_table=terraform

apply: ## Terraform Apply for DEV env
	@terraform apply -auto-approve -no-color

destroy: ## Terraform Destroy for DEV env
	@terraform destroy -auto-approve -no-color



