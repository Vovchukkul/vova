output "ecs_sg" {
  value = aws_security_group.ecs.id
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_backend_service_name" {
  value = aws_ecs_service.backend.name
}
