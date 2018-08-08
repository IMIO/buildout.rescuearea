#!/bin/sh
# Usage:
#     ./bootstrap.sh  # use buildout.cfg
#     ./bootstrap.sh -c dev.cfg  # use dev.cfg
ln -s dev.cfg buildout.cfg
virtualenv -p python2.7 .
bin/pip install -I -r requirements.txt
bin/buildout "$@"
