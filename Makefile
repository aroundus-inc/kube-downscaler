.PHONY: test docker push

IMAGE            ?= hjacobs/kube-downscaler
VERSION          ?= $(shell git describe --tags --always --dirty)
TAG              ?= $(VERSION)

default: docker

test:
	pipenv run flake8
	pipenv run coverage run --source=kube_downscaler -m py.test -v
	pipenv run coverage report

docker: 
	docker build --build-arg "VERSION=$(VERSION)" -t "$(IMAGE):$(TAG)" .
	@echo 'Docker image $(IMAGE):$(TAG) can now be used.'

push: docker
	docker push "$(IMAGE):$(TAG)"
	docker tag "$(IMAGE):$(TAG)" "$(IMAGE):latest"
	docker push "$(IMAGE):latest"
