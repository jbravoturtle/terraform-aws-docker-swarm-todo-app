#!/bin/bash
# Use the bash shell to execute this script

set -e
# Exit immediately if any command exits with a non-zero status (i.e., if any command fails)

set -x
# Print each command before executing it (useful for debugging)

yum update -y
# Update all packages on the system to their latest available versions

yum install -y docker git
# Install Docker and Git without asking for confirmation

systemctl enable docker
# Enable Docker to start on boot

systemctl start docker
# Start the Docker service

docker swarm init
# Initialize a Docker Swarm cluster on this node (it becomes the manager node)

git clone https://github.com/dockersamples/todo-list-app.git
# Clone the sample To-Do List application from GitHub

cd todo-list-app
# Change the directory to the cloned repository

sudo docker build -t todo-app .
# Build a Docker image for the To-Do List application and tag it as "todo-app"

docker network create --driver overlay swarm-network
# Create a Docker overlay network called "swarm-network" for inter-service communication in the Swarm cluster

sudo docker service create \
  --name todo-app \
  --replicas 6 \
  --publish 3000:3000 \
  --network swarm-network \
  todo-app
# Create a Docker service named "todo-app" with 6 replicas
# Publish the service on port 3000 so it can be accessed from outside the cluster
# Connect the service to the "swarm-network" overlay network
# Use the "todo-app" image built earlier
