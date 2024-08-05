Terraform AWS Docker Swarm Setup for To-Do List Application

Overview

This repository contains Terraform configurations to set up a Docker Swarm cluster on AWS, which deploys a sample To-Do List application. 
The infrastructure includes a VPC, subnets, security groups, an Application Load Balancer (ALB), Auto Scaling Groups (ASG), and EC2 instances. 
This setup is part of a technical interview task (refer to interview_task.txt for more details).

Architecture

The infrastructure includes:

VPC: A custom Virtual Private Cloud with two public subnets, ensuring network isolation and management.
Subnets: Two public subnets, each located in different availability zones for high availability.
Internet Gateway and Route Tables: To enable internet access for the instances within the VPC.
Security Groups: Configured to allow necessary inbound and outbound traffic to and from the instances.
Application Load Balancer: Distributes incoming traffic across Docker Swarm nodes to ensure scalability and reliability.
Auto Scaling Group: Manages the EC2 instances, scaling the Docker Swarm cluster up or down based on load and demand.
Elastic IPs: Assigned to the Swarm manager nodes to provide static IP addresses, ensuring consistent access.
Prerequisites

Before running the Terraform scripts, ensure you have the following:

Terraform v1.x.x
AWS CLI configured with appropriate IAM permissions
SSH key pair for EC2 access (the public key will be handled by the setup script)
Usage

1. Clone the Repository
First, clone the repository to your local machine:

git clone https://github.com/jbravoturtle/terraform-aws-docker-swarm-todo-app.git
cd terraform-aws-docker-swarm-todo-app

2. Initialize and Apply Terraform Configuration
No manual key pair creation is necessary. The provided startup.sh script will:

Create the necessary key pair.
Clean up any existing Terraform state files.
Initialize Terraform and apply the configurations.
To execute the script, run the following commands:

chmod +x startup.sh
./startup.sh
You will be prompted to enter your AWS cli credentials.

3. Access the To-Do List Application
Once the infrastructure is provisioned, the script will output the DNS name of the Application Load Balancer. To access the application:

Copy the DNS name provided by the script.
Paste it into your web browser's address bar.
You should see the running To-Do List application.

Cleanup

To destroy the infrastructure and clean up all AWS resources, run:

terraform destroy
This will remove all the resources created by Terraform.