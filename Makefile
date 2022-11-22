# Metadata about this makefile and position
MKFILE_PATH := $(lastword $(MAKEFILE_LIST))
CURRENT_DIR := $(patsubst %/,%,$(dir $(realpath $(MKFILE_PATH))))

TERRAFORM_DIR ?= "."

terraform-fmt-check:
	@$(CURRENT_DIR)/build-scripts/terraformfmtcheck.sh $(TERRAFORM_DIR)
.PHONY: terraform-fmt-check