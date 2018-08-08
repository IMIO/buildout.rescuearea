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
