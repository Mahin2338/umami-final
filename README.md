Umami Final Project 🚀

A cloud-native deployment of the Umami analytics application using Terraform for Infrastructure as Code (IaC) and GitHub Actions for CI/CD.
This project demonstrates how to build, deploy, and manage a real-world app on AWS ECS (Fargate) with RDS PostgreSQL, showing end-to-end automation of infrastructure and deployments.

⸻

📌 Project Overview

The goal of this project was to simulate a real cloud engineer/DevOps workflow:
	•	Write reproducible infrastructure with Terraform.
	•	Store state securely in an S3 backend.
	•	Automate provisioning and deployments via GitHub Actions.
	•	Deploy Umami as a container on AWS ECS, backed by PostgreSQL RDS.

This setup mirrors production-grade cloud deployments and demonstrates IaC, CI/CD, and cloud-native app hosting.

⸻

🏗️ Architecture Flow:
	1.	Developer pushes code → GitHub Actions triggers pipeline.
	2.	Pipeline runs Terraform to provision/update AWS resources.
	3.	Terraform creates VPC, subnets, security groups, ECS cluster, and RDS.
	4.	ECS pulls the container image and runs Umami.
	5.	App is accessible through an Application Load Balancer (ALB) and also mapped to my own custom domain via ROUTE53
 

⸻

⚙️ Technologies Used
	•	AWS ECS (Fargate) – container orchestration
	•	AWS RDS (PostgreSQL) – relational database
	•	AWS VPC, Subnets, Security Groups – networking & security
	•	AWS Application Load Balancer (ALB) – traffic routing
	•	Terraform – Infrastructure as Code
	•	S3 + DynamoDB – remote state backend
	•	GitHub Actions – CI/CD pipeline

⸻

🚀 Deployment Flow
	1.	Code push to GitHub
	•	Triggers workflow in .github/workflows/ci-cd.yml
	2.	GitHub Actions pipeline
	•	Configures AWS credentials (from GitHub Secrets)
	•	Runs Terraform init, plan, and apply
	3.	Terraform
	•	Provisions VPC, ECS cluster, RDS, security groups
	•	Creates/load balances target groups
	4.	ECS
	•	Pulls container image (currently from ghcr.io/umami-software/umami)
	•	Runs the app on Fargate

⸻

📸 Screenshots
	•	GitHub Actions run: 
 
 
 
 🔮 Future Improvements
 
	•	Add Docker build & push to ECR (instead of GHCR)
	•	Configure autoscaling for ECS service
	•	Add CloudWatch monitoring and alerting
	• Improve cost optimization eg. automatic shutdown for non-prod environments
	•	Add multi-environment support (dev/stage/prod)

⸻

📚 Learning Outcomes

This project demonstrates:
	•	Setting up Infrastructure as Code (IaC) with Terraform.
	•	Managing remote Terraform state in S3/DynamoDB.
	•	Automating deployments via CI/CD with GitHub Actions.
	•	Deploying a real-world app on AWS ECS + RDS.
