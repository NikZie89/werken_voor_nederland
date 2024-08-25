#!/bin/bash

# Pull Selenium Firefox image van docker
echo "Pulling the Selenium Firefox standalone Docker image..."
docker pull selenium/standalone-firefox:2.53.0

# Check container en map de ports
echo "Starting the Selenium container..."
docker run -d -p 4445:4444 selenium/standalone-firefox:2.53.0

echo "Checking if the Selenium container is running..."
docker ps | grep selenium-standalone