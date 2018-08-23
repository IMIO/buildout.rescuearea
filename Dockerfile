FROM docker-staging.imio.be/base:latest
ARG repo=buildout.rescuearea
# Removed libtiff5-dev
RUN utily="python-pip" \
  && buildDeps="libpq-dev wget git python-virtualenv gcc libc6-dev libpcre3-dev libssl-dev libxml2-dev libxslt1-dev libbz2-dev libffi-dev libjpeg62-dev libopenjp2-7-dev zlib1g-dev python-dev" \
  && apt-get update \
  && apt-get install -y --no-install-recommends $buildDeps \
  && apt-get install -y --no-install-recommends $utily \
  && pip install pip==10.0.1 \
  && mkdir /home/imio/.buildout
COPY default.cfg /home/imio/.buildout/default.cfg
RUN chown -R imio:imio /home/imio/
USER imio
ENV PATH="/home/imio/.local/bin:${PATH}"
RUN git clone https://github.com/IMIO/${repo}.git /home/imio/plone
WORKDIR /home/imio/plone
RUN pip install --user -I -r requirements.txt \
 && buildout -c prod.cfg
USER root
WORKDIR /home/imio/
RUN apt-get purge -y --auto-remove $buildDeps \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf plone \
  && rm -rf /home/imio/.local \
  && rm -rf /home/imio/.cache \
  && rm -rf /home/imio/.buildout/downloads/*
