# docker-beanstalkd

[![Docker Pulls](https://img.shields.io/docker/pulls/maateen/docker-beanstalkd.svg)](https://hub.docker.com/r/maateen/docker-beanstalkd)
[![Docker Stars](https://img.shields.io/docker/stars/maateen/docker-beanstalkd.svg)](https://hub.docker.com/r/maateen/docker-beanstalkd)
[![Docker Image Size](https://img.shields.io/docker/image-size/maateen/docker-beanstalkd/latest.svg)](https://hub.docker.com/r/maateen/docker-beanstalkd)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/maateen/docker-beanstalkd/docker-push.yml?branch=main)](https://github.com/maateen/docker-beanstalkd/actions)
[![GitHub License](https://img.shields.io/github/license/maateen/docker-beanstalkd)](https://github.com/maateen/docker-beanstalkd/blob/main/LICENSE)

A Docker container for Beanstalkd, a simple and fast general-purpose work queue.

## Quick Reference

- **Where to file issues**: [GitHub Issues](https://github.com/maateen/docker-beanstalkd/issues)
- **Where to get help**: [GitHub Issues](https://github.com/maateen/docker-beanstalkd/issues)
- **Image updates**: [GitHub Pull Requests](https://github.com/maateen/docker-beanstalkd/pulls)

## Supported Registries

- [Docker Hub](https://hub.docker.com/r/maateen/docker-beanstalkd)
- [GitHub Container Registry](https://github.com/maateen/docker-beanstalkd/pkgs/container/docker-beanstalkd)

## Supported Tags

- `v1.13-alpine-3.21`, `v1.13-alpine-3.20`, `v1.13-alpine-3.19`, `v1.13-alpine-3.18`
- `v1.12-alpine-3.21`, `v1.12-alpine-3.20`, `v1.12-alpine-3.19`, `v1.12-alpine-3.18`
- `v1.11-alpine-3.21`, `v1.11-alpine-3.20`, `v1.11-alpine-3.19`, `v1.11-alpine-3.18`
- `v1.10-alpine-3.21`, `v1.10-alpine-3.20`, `v1.10-alpine-3.19`, `v1.10-alpine-3.18`
- `v1.9-alpine-3.21`, `v1.9-alpine-3.20`, `v1.9-alpine-3.19`, `v1.9-alpine-3.18`
- `v1.8-alpine-3.21`, `v1.8-alpine-3.20`, `v1.8-alpine-3.19`, `v1.8-alpine-3.18`

## What is Beanstalkd?

Beanstalkd is a simple, fast work queue. Its interface is generic but was originally designed for reducing the latency of page views in high-volume web applications by running time-consuming tasks asynchronously. For more information and related downloads for Beanstalkd, please visit [beanstalkd.github.io](https://beanstalkd.github.io/).

## How to Use This Image

### Using Docker Hub

```bash
docker run --name some-beanstalkd -d maateen/docker-beanstalkd
```

### Using GitHub Container Registry

```bash
docker run --name some-beanstalkd -d ghcr.io/maateen/docker-beanstalkd
```

### Start with Persistent Storage

```bash
docker run --name some-beanstalkd -v $(pwd):/var/cache/beanstalkd -d maateen/docker-beanstalkd
```

### Exposing External Port

```bash
docker run --name some-beanstalkd -d -p 11300:11300 maateen/docker-beanstalkd
```

## Environment Variables

- **PV_DIR**: Use a binlog to keep jobs on persistent storage in directory PV_DIR. Upon startup, Beanstalkd will recover any binlog that is present in PV_DIR, then, during normal operation, append new jobs and changes in state to the binlog.
- **FSYNC_INTERVAL**: Call `fsync(2)` at most once every FSYNC_INTERVAL milliseconds. Larger values for FSYNC_INTERVAL reduce disk activity and improve speed at the cost of safety. A power failure could result in the loss of up to FSYNC_INTERVAL milliseconds of history. A FSYNC_INTERVAL value of 0 will cause Beanstalkd to call fsync every time it writes to the binlog.

## Image Variants

The Beanstalkd images are based on [Alpine Linux](https://alpinelinux.org/) and are available for multiple architectures:
- linux/amd64
- linux/arm64

Each variant is built with different Alpine Linux versions (3.18 to 3.21) and Beanstalkd versions (1.8 to 1.13), allowing you to choose the most appropriate combination for your needs.

## License

View [license information](https://github.com/maateen/docker-beanstalkd/blob/main/LICENSE) for the software contained in this image. As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc., from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
