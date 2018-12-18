#!/bin/bash

docker container run -d \
--rm \
--user root \
--name jenkins \
--publish 8080:8080 \
--volume jenkins-data:/var/jenkins_home \
--volume /var/run/docker.sock:/var/run/docker.sock \
--volume $PWD:/home/GitHub/simple-java-maven-app \
jenkinsci/blueocean
