Troubleshooting Guide for To-Do List Application

This guide provides quick solutions to common issues that may arise while running the To-Do List application on Docker Swarm.

The script.sh will provide public IPs for the Swarm nodes.
you will be able to access the application using the following command:

"The script will create the necessary key pair for the mentioned location below"
ssh -i ~/.ssh/my-key-pair ec2-user@<instance_public_ip>

If you lose the ip address of the instance, you can retrieve it using the following command:
terraform show

Checking Docker Swarm Status

To check the status of Docker Swarm and the running services:

Check Nodes Status:

docker node ls
Ensure all nodes are in the Ready state.
Check Services Status:

docker service ls
Verify that the todo-app service has the expected number of replicas running.
Viewing Application Logs

If the application isn't working as expected, viewing logs can help identify the issue:

View Logs for todo-app Service:

docker service logs todo-app
View Logs for a Specific Container:
First, get the container ID:

docker ps
Then, view the logs:


docker logs <container_id_or_name>
Connecting to Containers

To troubleshoot or inspect running containers, you might need to connect to them directly:

Connect to the Application Container:
First, identify the container ID for the application:

docker ps --filter "name=todo-app"
Then, connect to the container:

docker exec -it <container_id_or_name> /bin/sh
This allows you to interact with the application environment.
Connect to the MySQL Database Container:
Identify the container ID for the MySQL container:

docker ps --filter "name=mysql"
Then, connect to the MySQL shell inside the container:

docker exec -it <container_id_or_name> mysql -u <username> -p<password>
Once connected, you can run SQL commands to check the database status or query data:


SHOW DATABASES;
USE <database_name>;
SHOW TABLES;
SELECT * FROM <table_name>;
Common Issues and Fixes

Service Not Starting:
Symptoms: todo-app service is not running or replicas are not being created.
Fix: Check the status of Docker Swarm nodes with docker node ls and view logs with docker service logs todo-app.

Application Not Accessible:
Symptoms: The application is not reachable via the load balancer.
Fix: Ensure the service is running and published on port 3000. Verify network connectivity and inspect logs.

Containers Restarting Frequently:
Symptoms: Containers for the todo-app service keep restarting.
Fix: View container logs with docker logs <container_id_or_name> to identify issues, and inspect resource usage with docker stats.