#!/usr/bin/make

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

docker-image:
	docker build --pull -t docker-staging.imio.be/rescuearea/mutual:latest .

rsync:
	rsync -P imio@staging.lan.imio.be:/srv/instances/zhc/filestorage/Data.fs var/filestorage/Data.fs
	rsync -r --info=progress2 imio@staging.lan.imio.be:/srv/instances/zhc/blobstorage/ var/blobstorage/
