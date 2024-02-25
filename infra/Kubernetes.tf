resource "kubernetes_deployment" "Django-API" {
  metadata {
    name = "django-api"
    labels = {
      name = "django"
    }
  }

  spec { # Must match the labels
    replicas = 3 # Number of replicas that will be created and running at same time for this deployment

    selector {
      match_labels = {
        name = "django" # must match with metadata block
      }
    }

    template {
      metadata {
        labels = { # must match with metadata block
          name = "django"
        }
      }

      spec {
        container { # The image is the one stored at ECR. You can find the link at the command used to push to ECR. 
          image = "273917849797.dkr.ecr.us-west-2.amazonaws.com/production:latest"
          name  = "django" # Don't need to match, just a reference name

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/clientes/" # Path that must be accessed to be considered healthy
              port = 8000 # Port obviously must be open

              http_header { # (optional) Custom headers can be added here if needed
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3 # Delay before being considered healthy for the first time. If the application take much time to deploy, adjust as needed to avoid false positives.
            period_seconds        = 6 # (3) Time between probes (frequency). Adjust as needed. Not much low, neither to high. 3 failures in a row would be considered unhealthy.
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "LoadBalancer" {
  metadata {
    name = "loadbalancer-django-api"
  }
  spec {
    port {
      port        = 8000 # machine port
      target_port = 8000 # container port
    }
  
  selector = { # Useful when you have multiple pods with the same label.(Optional) Route service traffic to pods with label keys and values matching this selector. Only applies to types ClusterIP, NodePort, and LoadBalancer. For more info see Kubernetes reference documentation https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service
    name = "django"
    # app = kubernetes_pod.example.metadata.0.labels.app
    }

    session_affinity = "ClientIP" # (Optional) Type of session affinity to use. Valid values are 'None' and 'ClientIP'. Defaults to 'None' if not specified. User will use the same container if enabled. There's a timeout of about 3 hours.
    type = "LoadBalancer"
  }
}

  data "kubernetes_service" "DNSName" {
    metadata {
      name = "loadbalancer-django-api"
    }
  }

  output "URL" {
    value = data.kubernetes_service.DNSName.status # outputs the URL for the load balancer
  }

# # Create a local variable for the load balancer name.
# locals {
#   lb_name = split("-", split(".", kubernetes_service.example.status.0.load_balancer.0.ingress.0.hostname).0).0
# }

# # Read information about the load balancer using the AWS provider.
# data "aws_elb" "example" {
#   name = local.lb_name
# }

# output "load_balancer_name" {
#   value = local.lb_name
# }

# output "load_balancer_hostname" {
#   value = kubernetes_service.example.status.0.load_balancer.0.ingress.0.hostname
# }

# output "load_balancer_info" {
#   value = data.aws_elb.example
# }