#!/usr/bin/make
IMAGE_NAME="docker-staging.imio.be/rescuearea/mutual:latest"

build-dev: bin/python
	ln -fs dev.cfg buildout.cfg
	bin/pip install -I -r requirements.txt
	bin/buildout

build-prod: bin/python
	ln -fs prod.cfg buildout.cfg
	bin/pip install -I -r requirements.txt
	bin/buildout

bin/python:
	virtualenv-2.7 .

run: bin/instance
	bin/instance fg

rsync:
	rsync -P imio@staging.lan.imio.be:/srv/instances/zhc/filestorage/Data.fs var/filestorage/Data.fs
	rsync -r --info=progress2 imio@staging.lan.imio.be:/srv/instances/zhc/blobstorage/ var/blobstorage/

.PHONY: docker-image
docker-image:
	docker build --no-cache --pull -t rescuearea/mutual:latest .

eggs:  ## Copy eggs from docker image to speed up docker build
	-docker run --entrypoint='' $(IMAGE_NAME) tar -c -C /plone eggs | tar x
	mkdir -p eggs
