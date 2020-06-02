#!/bin/bash

repo_name="maateen/docker-beanstalkd"
build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
alpine_versions=('3.9' '3.10' '3.11' '3.12' 'latest' 'edge')
beanstalkd_versions=('1.8' '1.9' '1.10' '1.11')

buildNpush() {
    alpine_version=$1
    beanstalkd_version=$2
    echo "Building beanstalkd-$beanstalkd_version on alpine:$alpine_version"
    docker build -t $repo_name:$beanstalkd_version-alpine-$alpine_version --build-arg ALPINE_VERSION=$alpine_version --build-arg BEANSTALKD_VERSION=$beanstalkd_version --build-arg VCS_REF=$TRAVIS_COMMIT --build-arg BUILD_DATE=$build_date .
    docker push $repo_name:$beanstalkd_version-alpine-$alpine_version

    if [[ "${alpine_version}" == "edge" ]] && [[ "${beanstalkd_version}" == "master" ]]; then
        docker tag $repo_name:$beanstalkd_version-alpine-$alpine_version $repo_name:latest
        docker push $repo_name:latest
    fi
}

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

if [[ "${TRAVIS_EVENT_TYPE}" == "cron" ]]; then
    beanstalkd_version="master"
    for alpine_version in "${alpine_versions[@]}"; do
        buildNpush $alpine_version $beanstalkd_version
    done
else
    for alpine_version in "${alpine_versions[@]}"; do
        for beanstalkd_version in "${beanstalkd_versions[@]}"; do
            buildNpush $alpine_version $beanstalkd_version
        done
    done
fi

# Webhooks
curl -X POST "https://hooks.microbadger.com/images/maateen/docker-beanstalkd/cJ6YwSmK3M8-7iGdWYPYQoST-iY\="