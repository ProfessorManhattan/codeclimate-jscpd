.PHONY: image test

IMAGE_NAME ?= codeclimate/codeclimate-jscpd

SLIM_IMAGE_NAME ?= codeclimate/codeclimate-jscpd:slim

image:
	docker build --rm -t $(IMAGE_NAME) .

slim: image
	docker-slim build --tag $(SLIM_IMAGE_NAME) --http-probe=false  --exec '/usr/src/app/bin/codeclimate-jscpd.js || continue' --mount "$$PWD/tests/example:/code" --workdir '/code' --preserve-path-file 'paths.txt' $(IMAGE_NAME) && prettier --write slim.report.json

test: slim
	container-structure-test test --image $(IMAGE_NAME) --config tests/container-test-config.yaml && container-structure-test test --image $(SLIM_IMAGE_NAME) --config tests/container-test-config.yaml

