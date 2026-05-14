.PHONY: all build runtime

export DOCKER_BUILDKIT=0

all: all314 all312 all310
all314: pull314 build314 runtime314
all312: pull312 build312 runtime312
all310: pull310 build310 runtime310

pull: pull314 pull312 pull310
build: build314 build312 build310
runtime: runtime314 runtime312 runtime310
push: push314 push312 push310
clean: clean314 clean312 clean310

# Ensure builds stack on top of the latest version of the base image.
# A manual pull is used instead of `docker build --pull` to avoid repulling our own images.
pull314:
	docker pull python:3.14-trixie
	docker pull python:3.14-slim-trixie

pull312:
	docker pull python:3.12-bookworm
	docker pull python:3.12-slim-bookworm

pull310:
	docker pull python:3.10-bullseye
	docker pull python:3.10-slim-bullseye

## Building build container
build314:
	docker build -t edoburu/django-base-images:py314-trixie-build ./py314-trixie-build/
	docker build -t edoburu/django-base-images:py314-trixie-build-onbuild ./py314-trixie-build/onbuild/

build312:
	docker build -t edoburu/django-base-images:py312-bookworm-build ./py312-bookworm-build/
	docker build -t edoburu/django-base-images:py312-bookworm-build-onbuild ./py312-bookworm-build/onbuild/

build310:
	docker build -t edoburu/django-base-images:py310-bullseye-build ./py310-bullseye-build/
	docker build -t edoburu/django-base-images:py310-bullseye-build-onbuild ./py310-bullseye-build/onbuild/

## Building runtime container
runtime314:
	docker build -t edoburu/django-base-images:py314-trixie-runtime ./py314-trixie-runtime/
	docker build -t edoburu/django-base-images:py314-trixie-runtime-onbuild ./py314-trixie-runtime/onbuild/

runtime312:
	docker build -t edoburu/django-base-images:py312-bookworm-runtime ./py312-bookworm-runtime/
	docker build -t edoburu/django-base-images:py312-bookworm-runtime-onbuild ./py312-bookworm-runtime/onbuild/

runtime310:
	docker build -t edoburu/django-base-images:py310-bullseye-runtime ./py310-bullseye-runtime/
	docker build -t edoburu/django-base-images:py310-bullseye-runtime-onbuild ./py310-bullseye-runtime/onbuild/

## Pushing
push314:
	docker push edoburu/django-base-images:py314-trixie-build
	docker push edoburu/django-base-images:py314-trixie-build-onbuild
	docker push edoburu/django-base-images:py314-trixie-runtime
	docker push edoburu/django-base-images:py314-trixie-runtime-onbuild

push312:
	docker push edoburu/django-base-images:py312-bookworm-build
	docker push edoburu/django-base-images:py312-bookworm-build-onbuild
	docker push edoburu/django-base-images:py312-bookworm-runtime
	docker push edoburu/django-base-images:py312-bookworm-runtime-onbuild

push310:
	docker push edoburu/django-base-images:py310-bullseye-build
	docker push edoburu/django-base-images:py310-bullseye-build-onbuild
	docker push edoburu/django-base-images:py310-bullseye-runtime
	docker push edoburu/django-base-images:py310-bullseye-runtime-onbuild

## Cleaning
clean314:
	docker rmi edoburu/django-base-images:py314-trixie-build edoburu/django-base-images:py314-trixie-build-onbuild edoburu/django-base-images:py314-trixie-runtime edoburu/django-base-images:py314-trixie-runtime-onbuild

clean312:
	docker rmi edoburu/django-base-images:py312-bookworm-build edoburu/django-base-images:py312-bookworm-build-onbuild edoburu/django-base-images:py312-bookworm-runtime edoburu/django-base-images:py312-bookworm-runtime-onbuild

clean310:
	docker rmi edoburu/django-base-images:py310-bullseye-build edoburu/django-base-images:py310-bullseye-build-onbuild edoburu/django-base-images:py310-bullseye-runtime edoburu/django-base-images:py310-bullseye-runtime-onbuild
