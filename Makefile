.DEFAULT_GOAL := help

repo := php
tags := 7.0 7.1 7.2 7.3 7.4

define build_git_branch
	git checkout master
	git fetch
	git branch -D $(1) || true
	git checkout -b $(1)
	sed -i -e "s@FROM $(repo):latest@FROM $(repo):$(1)@" Dockerfile
	git commit -am "Change base image to $(repo):$(1)"
	git push origin $(1) --force-with-lease
	git checkout master

endef

define build_docker_image
	@if [ -z "$(TRIGGER_URL)" ]; then \
		echo "TRIGGER_URL is empty."; \
		exit 1; \
	fi
	curl -H "Content-Type: application/json" --data "{\"source_type\": \"Branch\", \"source_name\": \"$(1)\"}" -X POST $(TRIGGER_URL)

endef

.PHONY: build
build: ## build all tags
	git fetch --all
	$(foreach tag,$(tags),$(call build_git_branch,$(tag)))

.PHONY: rebuild
rebuild: ## rebuild all tags
	$(foreach tag,$(tags),$(call build_docker_image,$(tag)))
	$(call build_docker_image,master)



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
