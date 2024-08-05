# Output the Elastic IPs of the swarm nodes
output "swarm_instance_elastic_ips" {
  value = [aws_eip.swarm_eip1.public_ip, aws_eip.swarm_eip2.public_ip, aws_eip.swarm_eip3.public_ip]
}

# Output the DNS name of the Load Balancer
output "load_balancer_dns" {
  value = aws_lb.web_lb.dns_name
}
