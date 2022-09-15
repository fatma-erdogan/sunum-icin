output "vpc-id" {
  value = aws_vpc.vpc.id
}
output "vpc-name" {
  value = aws_vpc.vpc.tags.Name
}
