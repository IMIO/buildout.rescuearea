FROM docker-staging.imio.be/base:alpine as builder
ENV PIP=9.0.3 \
  ZC_BUILDOUT=2.13.2 \
  SETUPTOOLS=41.0.1 \
  WHEEL=0.31.1 \
  PLONE_MAJOR=5.0 \
  PLONE_VERSION=5.0.8

RUN apk add --update --no-cache --virtual .build-deps \
  build-base \
  gcc \
  git \
  libc-dev \
  libffi-dev \
  libjpeg-turbo-dev \
  libpng-dev \
  tiff-dev \
  libwebp-dev \
  libxml2-dev \
  libxslt-dev \
  openssl-dev \
  openldap-devel \
  pcre-dev \
  wget \
  zlib-dev \
  && pip install pip==$PIP setuptools==$SETUPTOOLS zc.buildout==$ZC_BUILDOUT wheel==$WHEEL
WORKDIR /plone
RUN chown imio:imio -R /plone && mkdir /data && chown imio:imio -R /data
#COPY --chown=imio eggs /plone/eggs/
COPY --chown=imio *.cfg /plone/
RUN rm -f .installed.cfg .mr.developer.cfg
RUN su -c "buildout -t 45 -c prod.cfg" -s /bin/sh imio


FROM docker-staging.imio.be/base:alpine

ENV PIP=9.0.3 \
  ZC_BUILDOUT=2.13.2 \
  SETUPTOOLS=41.0.1 \
  WHEEL=0.31.1 \
  PLONE_MAJOR=5.0 \
  PLONE_VERSION=5.0.8 \
  TZ=Europe/Brussel

RUN mkdir /data && chown imio:imio -R /data
VOLUME /data/blobstorage
VOLUME /data/filestorage
WORKDIR /plone

RUN apk add --no-cache --virtual .run-deps \
  bash \
  rsync \
  libxml2 \
  libxslt \
  libpng \
  libjpeg-turbo \
  tiff \
  openssl \
  openldap


LABEL plone=$PLONE_VERSION \
  os="alpine" \
  os.version="3.10" \
  name="Plone 5.0.8" \
  description="Plone image for rescuearea extranet" \
  maintainer="Imio"

COPY --from=builder /usr/local/lib/python2.7/site-packages /usr/local/lib/python2.7/site-packages
COPY --chown=imio --from=builder /plone .

COPY --chown=imio docker-initialize.py docker-entrypoint.sh /
USER imio
EXPOSE 8081
HEALTHCHECK --interval=1m --timeout=5s --start-period=45s \
  CMD nc -z -w5 127.0.0.1 8081 || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]

ENV ZEO_HOST=db \
 ZEO_PORT=8100 \
 HOSTNAME_HOST=local \
 PROJECT_ID=imio \
 SMTP_QUEUE_DIRECTORY=/data/queue
