.DEFAULT_GOAL := help

define build_specific_version
	git checkout master
	git branch -D $(1) || true
	git checkout -b $(1)
	sed -i -e "s/FROM php:latest/FROM php:$(1)/" Dockerfile
	git commit -am "Change base image to php:$(1)"
	git push origin $(1) --force-with-lease
	git checkout master
endef

.PHONY: build
build: ## build all branches
	$(call build_specific_version,"7.0")
	$(call build_specific_version,"7.1")
	$(call build_specific_version,"7.2")
	$(call build_specific_version,"7.3")
	$(call build_specific_version,"7.4")



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
