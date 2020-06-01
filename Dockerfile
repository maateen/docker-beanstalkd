ARG ALPINE_VERSION=edge

FROM alpine:${ALPINE_VERSION} AS builder

ARG BEANSTALKD_VERSION=master

# install dependencies
RUN apk update --quiet --no-cache && \
    apk add --quiet --no-cache build-base git pkgconfig

WORKDIR /build

# build from source
RUN git clone https://github.com/kr/beanstalkd.git && \
    printenv && \
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
FROM alpine:${ALPINE_VERSION}

ENV PV_DIR /var/cache/beanstalkd
ENV FSYNC_INTERVAL 1000

COPY --from=builder /build/beanstalkd /usr/bin/

RUN mkdir -p ${PV_DIR}
VOLUME [${PV_DIR}]

EXPOSE 11300

HEALTHCHECK --interval=5s --timeout=2s --retries=3 CMD pgrep beanstalkd || exit 1

CMD /usr/bin/beanstalkd -b ${PV_DIR} -f ${FSYNC_INTERVAL}
