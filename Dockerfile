ARG ALPINE_VERSION="latest"

FROM public.ecr.aws/docker/library/alpine:${ALPINE_VERSION} AS builder

ARG BEANSTALKD_VERSION="v1.13"

# install dependencies
RUN apk update --quiet --no-cache && \
    apk add --quiet --no-cache build-base git pkgconfig

WORKDIR /build

# build from source
RUN git clone --depth 1 --branch $BEANSTALKD_VERSION https://github.com/beanstalkd/beanstalkd.git && \
    cd beanstalkd && \
    if [ -f "sd-daemon.c" ]; then \
        sed -i 's,sys/fcntl.h,fcntl.h,' sd-daemon.c; \
    fi && \
    make && \
    ./beanstalkd -v

###############
# Final Build #
###############
FROM public.ecr.aws/docker/library/alpine:${ALPINE_VERSION}

LABEL org.opencontainers.image.authors="Maksudur Rahman Maateen <maateen@outlook.com>"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.description="A Docker container for beanstalkd, a simple and fast general purpose work queue."
LABEL org.opencontainers.image.documentation="https://github.com/maateen/docker-beanstalkd"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://beanstalkd.github.io/"
LABEL org.opencontainers.image.title="maateen/docker-beanstalkd"
LABEL org.opencontainers.image.url="https://github.com/maateen/docker-beanstalkd"
LABEL org.opencontainers.image.vendor="Maksudur Rahman Maateen <maateen@outlook.com>"
LABEL org.opencontainers.image.version="${BEANSTALKD_VERSION}"

ENV PV_DIR /var/cache/beanstalkd
ENV FSYNC_INTERVAL 1000

COPY --from=builder /build/beanstalkd /usr/bin/

RUN mkdir -p ${PV_DIR}
VOLUME ${PV_DIR}

EXPOSE 11300

HEALTHCHECK --interval=5s --timeout=2s --retries=3 CMD pgrep beanstalkd || exit 1

CMD /usr/bin/beanstalkd -b ${PV_DIR} -f ${FSYNC_INTERVAL}
