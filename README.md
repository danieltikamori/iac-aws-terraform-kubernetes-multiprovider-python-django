# Infrastructure as Code with Terraform, multi provider (AWS) and Kubernetes deploying Python - Django API application

## Why this stack?

### Terraform?

Avoid manual mistakes, more control over the deployments, and more portability.

### Why AWS?

Reduce CAPEX and accelerate deployment time. You can choose another platform or use a hybrid approach.

### Why Kubernetes?

As an open-source project, you can use it in various environments. No strings attached to any vendor lock-in. You have full access to the source code.
For scalable applications that require a lot of resources (CPU/Memory). It's also a good choice for microservices.
For scalability and fault tolerance in a containerized environment.

## Preparing the environment

Install Terraform and AWS CLI.

Configure them.

Create a project directory and infra/, env/ and environment directories inside the env/ directory.

We had previously created another IaC project, so we will just copy some code.

## VPC

Create a `vpc.tf` file in the infra/ directory.

Configure as the example provided.

## Security groups

Create a `security_groups.tf` file in the infra/ directory.

Configure in a way to allow SSH access to the EKS cluster.

## EKS

Create `eks.tf` file in the infra/ directory.

Use terraform modules.
See: https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest


Configure EKS through the `eks.tf` module.


## Deploy the cluster for testing purposes

Open the terminal, at the desired environment directory (env/dev), run the following command:

```bash
terraform init
terraform apply
```

Check the deployment at AWS console, EKS.

If successful, we now can focus on the application.

## 2 providers

See: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

The example code uses a local path and local context.

For further reading, see these examples which demonstrate different approaches to keeping the cluster credentials up to date:

Azure AKS: https://github.com/hashicorp/terraform-provider-kubernetes/blob/main/_examples/aks/README.md

Amazon EKS: https://github.com/hashicorp/terraform-provider-kubernetes/blob/main/_examples/eks/README.md

Google GKE: https://github.com/hashicorp/terraform-provider-kubernetes/blob/main/_examples/gke/README.md

Open the link of the preferred provider and follow the instructions.

We will use EKS in this project.

At the repository, open kubernetes-config directory and then, main.tf file. Copy the code. Paste it in to `Providers.tf`.

Then, see this link to learn the usage: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth

"data" is a service that retrieves data from external sources. In our case, we are retrieving the credentials for the EKS cluster.

