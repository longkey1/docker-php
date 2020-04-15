.DEFAULT_GOAL := help

define apply_patch
	@if test -z $(hash); then \
	echo "not found git revision hash string."; \
		exit 1; \
	fi
	git checkout $(1) && git cherry-pick $(hash) && git push origin $(1) --force-with-lease
endef

define replace_master
	git checkout master
	git branch -D $(1)
	git checkout -b $(1)
	git push origin $(1) --force-with-lease
endef

.PHONY: build
build: ## build all branches
	$(call apply_patch,"7.0")
	$(call apply_patch,"7.1")
	$(call apply_patch,"7.2")
	$(call apply_patch,"7.3")
	$(call replace_master,"7.4")



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
