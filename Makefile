# Metadata about this makefile and position
MKFILE_PATH := $(lastword $(MAKEFILE_LIST))
CURRENT_DIR := $(patsubst %/,%,$(dir $(realpath $(MKFILE_PATH))))

TERRAFORM_DIR ?= "."

# Perform a terraform fmt check but don't change anything
terraform-fmt-check:
	@$(CURRENT_DIR)/build-scripts/terraformfmtcheck.sh $(TERRAFORM_DIR)
.PHONY: terraform-fmt-check

# Format all terraform files according to terraform fmt
terraform-fmt:
	@terraform fmt -recursive
.PHONY: terraform-fmt