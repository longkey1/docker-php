.DEFAULT_GOAL := help

define build_specific_version_branch
	git checkout master
	git branch -D $(2) || true
	git checkout -b $(2)
	sed -i -e "s@FROM $(1):latest@FROM $(1):$(2)@" Dockerfile
	git commit -am "Change base image to $(1):$(2)"
	git push origin $(2) --force-with-lease
	git checkout master
endef

.PHONY: build
build: ## build_specific_version_branch
	$(call build_specific_version_branch,$(repo),$(tag))



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
