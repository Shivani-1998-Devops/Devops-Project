# My Own Project

## Project Overview

This repository contains an AWS infrastructure and CI/CD setup using Terraform and Ansible:

- `terraform/` creates AWS networking resources, a public bastion host, and Jenkins-related EC2 instances
- `Ansible/` installs Jenkins on the master node and prepares a Jenkins slave node with Java, Maven, and Docker

## Repository Structure

- `terraform/provider.tf` - AWS provider configuration (`ap-south-1` region)
- `terraform/vpc.tf` - VPC, public/private subnets, IGW, NAT Gateway, route tables, security group, and EC2 instance definitions
- `terraform/ami.tf` - Ubuntu AMI data source configuration
- `terraform/ec2.tf` - EC2 instance resource definitions using Ubuntu AMI
- `Ansible/hosts` - inventory file with master and slave host IPs
- `Ansible/jenkins-master-setup.yaml` - Jenkins master installation and service setup
- `Ansible/jenkins-slave-setup.yaml` - Jenkins agent preparation with Maven and Docker
- `.gitignore` - ignores Terraform state, `.terraform` directories, Ansible retry files, editor files, and logs

## Prerequisites

1. AWS credentials configured locally, for example via `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` or `~/.aws/credentials`
2. Terraform installed
3. Ansible installed
4. SSH private key file available at `/opt/linux-key.pem` or updated path in `Ansible/hosts`
5. SSH access allowed to the target instances using the `ubuntu` user

## Terraform Setup

1. Open a terminal in the project root:
   ```bash
   cd "d:/Devops/real-project-udemy/Project 2/My-Own"
   ```

2. Initialize Terraform:
   ```bash
   terraform init terraform
   ```

3. Review the planned infrastructure:
   ```bash
   terraform plan -var='key_name=linux-key'
   ```

4. Apply the plan:
   ```bash
   terraform apply -var='key_name=linux-key'
   ```

5. Confirm the AWS resources are created successfully.

> Note: Terraform is configured to use the `ap-south-1` region.

## Ansible Setup

### Verify inventory and SSH key

Update `Ansible/hosts` with your instance IP addresses and the correct path to the SSH key.

The current inventory uses:

- Jenkins master: `10.1.1.85`
- Jenkins slave: `10.1.1.155`
- SSH user: `ubuntu`
- SSH key: `/opt/linux-key.pem`

### Run Jenkins master playbook

```bash
ansible-playbook -i Ansible/hosts Ansible/jenkins-master-setup.yaml
```

### Run Jenkins slave playbook

```bash
ansible-playbook -i Ansible/hosts Ansible/jenkins-slave-setup.yaml
```

## What the Ansible Playbooks Do

- `jenkins-master-setup.yaml`
  - updates apt cache
  - installs Java 21, wget, fontconfig, gnupg
  - adds the Jenkins apt repository
  - installs Jenkins
  - starts and enables the Jenkins service

- `jenkins-slave-setup.yaml`
  - updates apt cache
  - installs Java 21, wget, fontconfig, gnupg
  - downloads and installs Apache Maven
  - installs Docker
  - starts Docker and gives the `ubuntu` user permission to use it

## Notes

- The `terraform/ec2.tf` file creates three instances using a `for_each` loop for `jenkins-master`, `jenkins-agent`, and `ansible`
- The `web-sg` security group allows HTTP (80), SSH (22), and Jenkins (8080)
- The Ansible SSH key path should be present on the control machine running Ansible

## Cleanup

To destroy created AWS resources, run:

```bash
terraform destroy -var='key_name=linux-key' terraform
```
