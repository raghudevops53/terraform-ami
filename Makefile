help:           ## Show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## Terraform init for DEV env
	@terraform init -no-color

apply: ## Terraform Apply for DEV env
	@terraform apply -auto-approve -no-color

destroy: ## Terraform Destroy for DEV env
	@terraform destroy -auto-approve -no-color


