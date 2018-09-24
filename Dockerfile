FROM docker-staging.imio.be/base:latest
ARG repo=buildout.rescuearea
RUN mkdir /home/imio/.buildout
COPY default.cfg /home/imio/.buildout/default.cfg
# Removed libtiff5-dev
ENV PIP=9.0.3 \
  HOME=/home/imio
RUN utily="python-pip" \
  && buildDeps="libpq-dev wget git python-virtualenv gcc libc6-dev libpcre3-dev libssl-dev libxml2-dev libxslt1-dev libbz2-dev libffi-dev libjpeg62-dev libopenjp2-7-dev zlib1g-dev python-dev" \
  && apt-get update \
  && apt-get install -y --no-install-recommends $buildDeps \
  && apt-get install -y --no-install-recommends $utily \
  && pip install pip==$PIP \
  && git clone https://github.com/IMIO/${repo}.git /home/imio/plone \
  && cd /home/imio/plone \
  && pip install -r requirements.txt \
  && buildout -t 25 -c prod.cfg \
  && cd /home/imio/ \
  && apt-get purge -y --auto-remove $buildDeps \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf plone \
  && rm -rf /home/imio/.local \
  && rm -rf /home/imio/.cache \
  && rm -rf /home/imio/.buildout/downloads/* \
  && chown -R imio:imio /home/imio
