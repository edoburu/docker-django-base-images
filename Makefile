.PHONY: all build runtime

all: pull build runtime

# Ensure builds stack on top of the latest version of the base image.
# A manual pull is used instead of `docker build --pull` to avoid repulling our own images.
pull:
	docker pull python:3.6-stretch
	docker pull python:3.6-slim-stretch

build:
	## Building build container
	docker build -t edoburu/django-base-images:py36-stretch-build ./py36-stretch-build/
	docker build -t edoburu/django-base-images:py36-stretch-build-onbuild ./py36-stretch-build/onbuild/

runtime:
	## Building runtime container
	docker build -t edoburu/django-base-images:py36-stretch-runtime ./py36-stretch-runtime/
	docker build -t edoburu/django-base-images:py36-stretch-runtime-onbuild ./py36-stretch-runtime/onbuild/
