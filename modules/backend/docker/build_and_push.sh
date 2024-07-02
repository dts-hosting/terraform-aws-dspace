#!/bin/bash

docker compose build
docker tag docker-dspace-proxy lyrasis/dspace-proxy:latest
docker push lyrasis/dspace-proxy:latest
