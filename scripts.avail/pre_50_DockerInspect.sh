#!/bin/bash
#
# this is meant to be sourced by backup.sh and will use variables defined there
#
# inspects all existing containers and saved the definitions on a text file

log "DOCKER_INSPECT" "saving container definition"
docker ps -a -q | xargs docker inspect > /docker/docker_inspect.dump
