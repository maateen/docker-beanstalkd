#!/bin/bash

repo_name="maateen/docker-beanstalkd"
alpine_versions=('edge' 'latest' '3.12' '3.11' '3.10' '3.9')
beanstalkd_versions=('master' '1.11' '1.10' '1.9' '1.8')

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

for alpine_version in "${alpine_versions[@]}"; do
    for beanstalkd_version in "${beanstalkd_versions[@]}"; do
        echo "Building beanstalkd-$beanstalkd_version on alpine:$alpine_versions"
        docker build -t $repo_name:$beanstalkd_version-alpine-$alpine_versions --build-arg ALPINE_VERSION=$alpine_version --build-arg BEANSTALKD_VERSION=$beanstalkd_version .
        docker push $repo_name:$beanstalkd_version-alpine-$alpine_versions
    done
done
