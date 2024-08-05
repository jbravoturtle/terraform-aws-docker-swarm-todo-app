# Allocate Elastic IPs for Swarm Nodes
resource "aws_eip" "swarm_eip1" {
  domain = "vpc"
}

resource "aws_eip" "swarm_eip2" {
  domain = "vpc"
}

resource "aws_eip" "swarm_eip3" {
  domain = "vpc"
}

# Associate Elastic IPs with Instances in the ASG
resource "aws_eip_association" "swarm_eip_assoc1" {
  instance_id   = element(data.aws_instances.swarm_instances.ids, 0)
  allocation_id = aws_eip.swarm_eip1.id

  depends_on = [data.aws_instances.swarm_instances]
}

resource "aws_eip_association" "swarm_eip_assoc2" {
  instance_id   = element(data.aws_instances.swarm_instances.ids, 1)
  allocation_id = aws_eip.swarm_eip2.id

  depends_on = [data.aws_instances.swarm_instances]
}

resource "aws_eip_association" "swarm_eip_assoc3" {
  instance_id   = element(data.aws_instances.swarm_instances.ids, 2)
  allocation_id = aws_eip.swarm_eip3.id

  depends_on = [data.aws_instances.swarm_instances]
}
