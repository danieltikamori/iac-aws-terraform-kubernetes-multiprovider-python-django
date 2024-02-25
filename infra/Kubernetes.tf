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