ARG ALPINE_VERSION="latest"

FROM public.ecr.aws/docker/library/alpine:${ALPINE_VERSION} AS builder

ARG BEANSTALKD_VERSION="v1.13"
ARG BUILD_PATH="/build"

# hadolint ignore=DL3018
RUN apk add --no-cache \
    build-base \
    git \
    pkgconfig

WORKDIR ${BUILD_PATH}

# Build from source
RUN git clone --depth 1 --branch ${BEANSTALKD_VERSION} https://github.com/beanstalkd/beanstalkd.git . && \
    if [ -f "sd-daemon.c" ]; then \
        sed -i 's,sys/fcntl.h,fcntl.h,' sd-daemon.c; \
    fi && \
    make && \
    strip beanstalkd && \
    ./beanstalkd -v

# Final image
FROM public.ecr.aws/docker/library/alpine:${ALPINE_VERSION}

ARG BEANSTALKD_VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.opencontainers.image.authors="Maksudur Rahman Maateen <maateen@outlook.com>"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.description="A Docker container for beanstalkd, a simple and fast general purpose work queue."
LABEL org.opencontainers.image.documentation="https://github.com/maateen/docker-beanstalkd"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.revision="${VCS_REF}"
LABEL org.opencontainers.image.source="https://github.com/maateen/docker-beanstalkd"
LABEL org.opencontainers.image.title="maateen/docker-beanstalkd"
LABEL org.opencontainers.image.url="https://github.com/maateen/docker-beanstalkd"
LABEL org.opencontainers.image.vendor="Maksudur Rahman Maateen <maateen@outlook.com>"
LABEL org.opencontainers.image.version="${VERSION}"

ENV PV_DIR=/var/cache/beanstalkd \
    FSYNC_INTERVAL=1000

# Create non-root user
RUN addgroup -S beanstalkd && \
    adduser -S -G beanstalkd beanstalkd && \
    mkdir -p ${PV_DIR} && \
    chown -R beanstalkd:beanstalkd ${PV_DIR}

COPY --from=builder --chown=beanstalkd:beanstalkd /build/beanstalkd /usr/local/bin/

USER beanstalkd
WORKDIR ${PV_DIR}

VOLUME ${PV_DIR}
EXPOSE 11300

HEALTHCHECK --interval=5s --timeout=2s --retries=3 \
    CMD pgrep beanstalkd || exit 1

ENTRYPOINT ["beanstalkd"]
CMD ["-b", "/var/cache/beanstalkd", "-f", "1000"]
