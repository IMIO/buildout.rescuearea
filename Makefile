#!/usr/bin/make
# UID := $(shell id -u)
# docker build args to add after tests: --no-cache --force-rm
docker-build-cache:
	docker build --pull --no-cache --build-arg repo=buildout.rescuearea -t docker-staging.imio.be/rescuearea/cache:latest .
