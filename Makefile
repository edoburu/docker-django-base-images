.PHONY: all build runtime

all: all36 all37 all38
all36: pull36 build36 runtime36
all37: pull37 build37 runtime37
all38: pull38 build38 runtime38

pull: pull36 pull37 pull38
build: build36 build37 build38
runtime: runtime36 runtime37 runtime38
push: push36 push37 push38
clean: clean36 clean37 clean38

# Ensure builds stack on top of the latest version of the base image.
# A manual pull is used instead of `docker build --pull` to avoid repulling our own images.
pull36:
	docker pull python:3.6-stretch
	docker pull python:3.6-slim-stretch

pull37:
	docker pull python:3.7-stretch
	docker pull python:3.7-slim-stretch

pull38:
	docker pull python:3.8-buster
	docker pull python:3.8-slim-buster

## Building build container
build36:
	docker build -t edoburu/django-base-images:py36-stretch-build ./py36-stretch-build/
	docker build -t edoburu/django-base-images:py36-stretch-build-onbuild ./py36-stretch-build/onbuild/

build37:
	docker build -t edoburu/django-base-images:py37-stretch-build ./py37-stretch-build/
	docker build -t edoburu/django-base-images:py37-stretch-build-onbuild ./py37-stretch-build/onbuild/

build38:
	docker build -t edoburu/django-base-images:py38-buster-build ./py38-buster-build/
	docker build -t edoburu/django-base-images:py38-buster-build-onbuild ./py38-buster-build/onbuild/

## Building runtime container
runtime36:
	docker build -t edoburu/django-base-images:py36-stretch-runtime ./py36-stretch-runtime/
	docker build -t edoburu/django-base-images:py36-stretch-runtime-onbuild ./py36-stretch-runtime/onbuild/

runtime37:
	docker build -t edoburu/django-base-images:py37-stretch-runtime ./py37-stretch-runtime/
	docker build -t edoburu/django-base-images:py37-stretch-runtime-onbuild ./py37-stretch-runtime/onbuild/

runtime38:
	docker build -t edoburu/django-base-images:py38-buster-runtime ./py38-buster-runtime/
	docker build -t edoburu/django-base-images:py38-buster-runtime-onbuild ./py38-buster-runtime/onbuild/

push36:
	docker push edoburu/django-base-images:py36-stretch-build
	docker push edoburu/django-base-images:py36-stretch-build-onbuild
	docker push edoburu/django-base-images:py36-stretch-runtime
	docker push edoburu/django-base-images:py36-stretch-runtime-onbuild

push37:
	docker push edoburu/django-base-images:py37-stretch-build
	docker push edoburu/django-base-images:py37-stretch-build-onbuild
	docker push edoburu/django-base-images:py37-stretch-runtime
	docker push edoburu/django-base-images:py37-stretch-runtime-onbuild

push38:
	docker push edoburu/django-base-images:py38-buster-build
	docker push edoburu/django-base-images:py38-buster-build-onbuild
	docker push edoburu/django-base-images:py38-buster-runtime
	docker push edoburu/django-base-images:py38-buster-runtime-onbuild


clean36:
	docker rmi edoburu/django-base-images:py36-stretch-build edoburu/django-base-images:py36-stretch-build-onbuild edoburu/django-base-images:py36-stretch-runtime edoburu/django-base-images:py36-stretch-runtime-onbuild

clean37:
	docker rmi edoburu/django-base-images:py37-stretch-build edoburu/django-base-images:py37-stretch-build-onbuild edoburu/django-base-images:py37-stretch-runtime edoburu/django-base-images:py37-stretch-runtime-onbuild

clean38:
	docker rmi edoburu/django-base-images:py38-buster-build edoburu/django-base-images:py38-buster-build-onbuild edoburu/django-base-images:py38-buster-runtime edoburu/django-base-images:py38-buster-runtime-onbuild
