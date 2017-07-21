#!/bin/bash

docker rm -f `docker ps | grep ericw95/fngs-sic | awk '{ print $1 }'`
docker run -d -p 8062:8888 ericw95/fngs-sic:0.0.1
