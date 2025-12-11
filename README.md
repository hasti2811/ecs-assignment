# My Production level ECS project

### In this project I deploy a containerised app using Docker to AWS with Infrastructure as Code using Terraform and automating developer changes using GitHub Actions as my CI/CD.

## Project Overview

I have containerised an open source application using docker to ensure that the app runs the same on every environment. I used multistage builds in order to keep the docker image to a small size, I have also ensured that the Docker image runs as a rootless user for security purposes.

I created an ECR repo to store my image, and I made the infrastructure using ClickOps (deploying via the AWS console). This was just the first part, I tore it all down and began the infrastructure using Terraform as my Infrastructure as Code tool.

I then started the infrastructure for the project. I started with the provider block to ensure that I am deploying on AWS. I made modules for each resource I needed. Firstly I started with VPC so I made my public and private subnets, route tables, NAT gateways, internet gateways, and configured 2 availability zones within the region.

I created security groups for a load balancer which accepts HTTP, HTTPS, and my container port traffic from the internet. I then made a security group for the ECS tasks that accept the same traffic but only from the load balancer. This ensures that the ECS tasks do not get requests from the internet, the requests must come from the load balancer.

Then i set up the Application Load balancer, the ALB listeners, and a target group so that I can distribute traffic to both private subnets. I also made sure that HTTP requests are redirected to HTTPS.

I also made an ECR module to reference my existing ECR repo, this is so I can output my image URI.

I created a Route 53 and ACM module to point my domain to the ALB DNS name and to also give it a SSL/TLS certificate to enable HTTPS.

Then i created the ECS module so that I can run my image as a container on the AWS cloud.

Finally I automated code changes through CI/CD so that when a developer makes changes, they can build the docker image and push it to ECR from GitHub actions. This means that the terraform infrastructure can pull updated images. They can also apply the infrastructure and destroy it too because I have made pipelines for those functions too.

## Architecture Diagram

<img src="./readme-images/terraform arch.drawio.png">

File structure:

```
.
.github/
└── workflows
    ├── cd.yaml
    ├── ci.yaml
    └── destroy.yaml
infra
├── main.tf
├── modules
│   ├── acm
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── alb
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── ecr
│   │   ├── main.tf
│   │   └── output.tf
│   ├── ecs
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── route53
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── sg
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── provider.tf
├── terraform.tfvars
└── variables.tf
```

## Security Group for ALB

The security group for the load balancer allows incomming HTTP, HTTPS, and the docker image container port traffic from the IPv4 internet (0.0.0.0/0)

<img src="./readme-images/sg-alb.png">

The security group for the ECS tasks allows incoming HTTP, HTTPS, and the docker image container port traffic from the security group of the ALB

<img src="./readme-images/sg-ecs.png">

## The resource map for the VPC

<img src="./readme-images/public-rtb-resource-map.png">
<img src="./readme-images/private-rtb-1-resource-map.png">
<img src="./readme-images/private-rtb-2-resource-map.png">

## Local App Setup

```bash
yarn install
yarn build
yarn global add serve
serve -s build

#yarn start
http://localhost:3000/workspaces/default/dashboard

```
