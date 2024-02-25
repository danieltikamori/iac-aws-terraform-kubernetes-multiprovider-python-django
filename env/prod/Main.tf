module "prod" {
    source = "../../infra"

    repo_name = "production"
    # IAMRole = "production"
    # environment = "production"
    cluster_name = "production"
}

output "load_balancer_dns" {
  value = module.prod.URLs # from kubernetes.tf
}