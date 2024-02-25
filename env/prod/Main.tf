module "prod" {
    source = "../../infra"

    repo_name = "production"
    # IAMRole = "production"
    # environment = "production"
    cluster_name = "production"
}

output "IP_alb" {
  value = module.prod.IP
}