.PHONY: all build runtime

export DOCKER_BUILDKIT=0

all: all38 all310
all38: pull38 build38 runtime38
all310: pull310 build310 runtime310

pull: pull38 pull310
build: build38 build310
runtime: runtime38 runtime310
push: push38 push310
clean: clean38 clean310

# Ensure builds stack on top of the latest version of the base image.
# A manual pull is used instead of `docker build --pull` to avoid repulling our own images.
pull38:
	docker pull python:3.8-buster
	docker pull python:3.8-slim-buster

pull310:
	docker pull python:3.10-bullseye
	docker pull python:3.10-slim-bullseye

## Building build container
build38:
	docker build -t edoburu/django-base-images:py38-buster-build ./py38-buster-build/
	docker build -t edoburu/django-base-images:py38-buster-build-onbuild ./py38-buster-build/onbuild/

build310:
	docker build -t edoburu/django-base-images:py310-bullseye-build ./py310-bullseye-build/
	docker build -t edoburu/django-base-images:py310-bullseye-build-onbuild ./py310-bullseye-build/onbuild/

## Building runtime container
runtime38:
	docker build -t edoburu/django-base-images:py38-buster-runtime ./py38-buster-runtime/
	docker build -t edoburu/django-base-images:py38-buster-runtime-onbuild ./py38-buster-runtime/onbuild/

runtime310:
	docker build -t edoburu/django-base-images:py310-bullseye-runtime ./py310-bullseye-runtime/
	docker build -t edoburu/django-base-images:py310-bullseye-runtime-onbuild ./py310-bullseye-runtime/onbuild/

push38:
	docker push edoburu/django-base-images:py38-buster-build
	docker push edoburu/django-base-images:py38-buster-build-onbuild
	docker push edoburu/django-base-images:py38-buster-runtime
	docker push edoburu/django-base-images:py38-buster-runtime-onbuild

push310:
	docker push edoburu/django-base-images:py310-bullseye-build
	docker push edoburu/django-base-images:py310-bullseye-build-onbuild
	docker push edoburu/django-base-images:py310-bullseye-runtime
	docker push edoburu/django-base-images:py310-bullseye-runtime-onbuild


clean38:
	docker rmi edoburu/django-base-images:py38-buster-build edoburu/django-base-images:py38-buster-build-onbuild edoburu/django-base-images:py38-buster-runtime edoburu/django-base-images:py38-buster-runtime-onbuild

clean310:
	docker rmi edoburu/django-base-images:py310-bullseye-build edoburu/django-base-images:py310-bullseye-build-onbuild edoburu/django-base-images:py310-bullseye-runtime edoburu/django-base-images:py310-bullseye-runtime-onbuild
