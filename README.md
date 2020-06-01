# docker-beanstalkd

A Docker container for beanstalkd, a simple and fast general purpose work queue.

## Quick reference

- **Where to file issues**: https://github.com/maateen/docker-beanstalkd/issues
- **Where to get help**: https://github.com/maateen/docker-beanstalkd/issues
- **Image updates**: https://github.com/maateen/docker-beanstalkd/pulls

## Supported tags

- `latest` (regular builds, might be unstable)
- `master-alpine-edge`, `master-alpine-latest`, `master-alpine-3.12`, `master-alpine-3.11`, `master-alpine-3.10`, `master-alpine-3.9`
- `1.11-alpine-edge`, `1.11-alpine-latest` (**stable**), `1.11-alpine-3.12`, `1.11-alpine-3.11`, `1.11-alpine-3.10`, `1.11-alpine-3.9`
- `1.10-alpine-edge`, `1.10-alpine-latest`, `1.10-alpine-3.12`, `1.10-alpine-3.11`, `1.10-alpine-3.10`, `1.10-alpine-3.9`
- `1.9-alpine-edge`, `1.9-alpine-latest`, `1.9-alpine-3.12`, `1.9-alpine-3.11`, `1.9-alpine-3.10`, `1.9-alpine-3.9`
- `1.8-alpine-edge`, `1.8-alpine-latest`, `1.8-alpine-3.12`, `1.8-alpine-3.11`, `1.8-alpine-3.10`, `1.8-alpine-3.9`

## What is beanstalkd?

It is a simple, fast work queue. Its interface is generic, but was originally designed for reducing the latency of page views in high-volume web applications by running time-consuming tasks asynchronously.

For more information and related downloads for beanstalkd, please visit  [beanstalkd.github.io](https://beanstalkd.github.io/).

## How to use this image

### start a beanstalkd instance

```
$ docker run --name some-beanstalkd -d maateen/docker-beanstalkd
```

### start with persistent storage

```
$ docker run --name some-beanstalkd -v $(pwd):/var/cache/beanstalkd -d maateen/docker-beanstalkd
```

### exposing external port

```
$ docker run --name some-beanstalkd -d -p 11300:11300 maateen/docker-beanstalkd
```

## Environment Variables

### `PV_DIR`

Use a binlog to keep jobs on persistent storage in directory `PV_DIR`. Upon startup, **beanstalkd** will recover any binlog that is present in `PV_DIR`, then, during normal operation, append new jobs and changes in state to the binlog.

### `FSYNC_INTERVAL`

Call  [fsync](https://www.systutorials.com/docs/linux/man/2-fsync/)(2) at most once every  `FSYNC_INTERVAL`  milliseconds. Larger values for  `FSYNC_INTERVAL`  reduce disk activity and improve speed at the cost of safety. A power failure could result in the loss of up to  `FSYNC_INTERVAL`  milliseconds of history.

A  `FSYNC_INTERVAL`  value of 0 will cause  **beanstalkd**  to call fsync every time it writes to the binlog.

## Image Variants

The `beanstalkd` images come in many flavors, each designed for a specific use case.

###  `maateen/docker-beanstalkd:<beanstalkd_version>-alpine-<alpine_version>`

This image is based on the popular [Alpine Linux project](http://alpinelinux.org/), available in [the  `alpine`  official image](https://hub.docker.com/_/alpine). Alpine Linux is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

### Tagging confusion?

- `master` means the [master](https://github.com/beanstalkd/beanstalkd/tree/master) branch of **beanstalkd** project. New changes are always coming here, not so much stable.
- `alpine-edge` means current [development tree](https://wiki.alpinelinux.org/wiki/Aports_tree "Aports tree") of Alpine Linux. It consists of a APK repository called "edge" and contains the latest build of all available Alpine Linux packages. Those packages are updated on a regular basis. *"edge" is under constant development so be careful using it in production. It is possible that bugs in "edge" could cause data loss or could break your system.*
- `alpine-latest` means the [latest stable version](https://wiki.alpinelinux.org/wiki/Alpine_Linux:Releases) of Alpine Linux.

## License

View  [license information](https://github.com/beanstalkd/beanstalkd/blob/master/LICENSE)  for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
