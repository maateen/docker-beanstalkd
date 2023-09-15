ARG ALPINE_VERSION=edge

FROM alpine:${ALPINE_VERSION} AS builder

ARG BEANSTALKD_VERSION=master

# install dependencies
RUN apk update --quiet --no-cache && \
    apk add --quiet --no-cache build-base git pkgconfig

WORKDIR /build

# build from source
RUN git clone https://github.com/kr/beanstalkd.git && \
    cd beanstalkd && \
    if [ "${BEANSTALKD_VERSION}" != "master" ] ; then \
        git checkout tags/v${BEANSTALKD_VERSION}; \
    fi && \
    if [ -f "sd-daemon.c" ]; then \
        sed -i 's,sys/fcntl.h,fcntl.h,' sd-daemon.c; \
    fi && \
    make && \
    ./beanstalkd -v

###############
# Final Build #
###############
ARG ALPINE_VERSION=edge

FROM alpine:${ALPINE_VERSION}

ARG BEANSTALKD_VERSION=master

ARG BUILD_DATE
ARG VCS_REF
LABEL version=$BEANSTALKD_VERSION \
    maintainer="Maksudur Rahman Maateen <maateen@outlook.com>" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="maateen/docker-beanstalkd" \
    org.label-schema.description="A Docker container for beanstalkd, a simple and fast general purpose work queue." \
    org.label-schema.url="https://beanstalkd.github.io/" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/maateen/docker-beanstalkd" \
    org.label-schema.vendor="Maksudur Rahman Maateen" \
    org.label-schema.version=$BEANSTALKD_VERSION \
    org.label-schema.schema-version="1.0" \
    com.microscaling.docker.dockerfile="/Dockerfile" \
    com.microscaling.license="GPL-3.0"

ENV PV_DIR /var/cache/beanstalkd
ENV FSYNC_INTERVAL 1000

COPY --from=builder /build/beanstalkd /usr/bin/

RUN mkdir -p ${PV_DIR}
VOLUME ${PV_DIR}

EXPOSE 11300

HEALTHCHECK --interval=5s --timeout=2s --retries=3 CMD pgrep beanstalkd || exit 1

CMD /usr/bin/beanstalkd -b ${PV_DIR} -f ${FSYNC_INTERVAL}
