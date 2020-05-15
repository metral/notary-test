#!/bin/bash

REPO=$1
TAG=$2
IMAGE_TAG="$REPO:$TAG"

NOTARY_AUTH=$(printf "%s:%s" "$DOCKER_USERNAME" "$DOCKER_PASSWORD" | base64)
export NOTARY_AUTH
export NOTARY_ROOT_PASSPHRASE='b@ds3crete'

export DOCKER_CONTENT_TRUST=1
export DOCKER_CONTENT_TRUST_SERVER="https://notary.docker.io"
export DOCKER_CONTENT_TRUST_REPOSITORY_PASSPHRASE=$NOTARY_AUTH
# only used for initial creation of keys if ~/.docker/trust DNE.
# it is not needed on proceeding runs of this script once keys are created.
export DOCKER_CONTENT_TRUST_ROOT_PASSPHRASE=$NOTARY_ROOT_PASSPHRASE 

docker build --rm -t "$IMAGE_TAG" .
docker push "$IMAGE_TAG"
