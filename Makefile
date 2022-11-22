# Metadata about this makefile and position
MKFILE_PATH := $(lastword $(MAKEFILE_LIST))
CURRENT_DIR := $(patsubst %/,%,$(dir $(realpath $(MKFILE_PATH))))

terraform-fmt-check:
	@$(CURRENT_DIR)/build-scripts/terraformfmtcheck.sh
.PHONY: terraform-fmt-check