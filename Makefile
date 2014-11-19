IMAGE=d11wtq/php

.PHONY: build push

build:
	docker build -t $(IMAGE) .
	docker tag $(IMAGE):latest $(IMAGE):$(VERSION)

push: build
	docker push $(IMAGE)
