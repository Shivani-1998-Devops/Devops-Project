# Prepare Terraform Environment on Windows

This guide will help you set up a complete Terraform development environment on Windows, including:

- Terraform
- Visual Studio Code (VS Code)
- AWS CLI

## Prerequisites

- Windows 10/11
- Administrator access
- Internet connection

## 1. Install Terraform

### Step 1: Download Terraform
Download the latest Terraform version from the official HashiCorp website:  
[Terraform Downloads](https://www.terraform.io/downloads.html)

### Step 2: Extract Terraform

- Download the Windows AMD64 ZIP file.
- Extract the ZIP file.
- Move `terraform.exe` to a permanent folder.

Example:
```
C:\Program Files\Terraform
```

### Step 3: Configure Environment Variables
Add Terraform to System PATH

- Click Start
- Search for: "Edit the system environment variables"
- Open it.
- Click "Environment Variables"
- Under System Variables, select: "Path"
- Click "Edit"
- Click "New"
- Add the Terraform installation path: `C:\Program Files\Terraform`
- Click OK to save all changes.

### Step 4: Verify Terraform Installation
Open Command Prompt or PowerShell and run:
```bash
terraform -version
```
Expected output:
```
Terraform v1.8.x on windows_amd64
```

Note: Version numbers may vary depending on the latest release.

## 2. Install Visual Studio Code (VS Code)

### Step 1: Download VS Code
Download the latest version from the official website:  
[Visual Studio Code](https://code.visualstudio.com/)

### Step 2: Install VS Code
Run the installer and keep the recommended options enabled:

- Add to PATH
- Register Code as editor
- Add "Open with Code" action

### Recommended VS Code Extensions for Terraform
Open VS Code → Extensions → Install:

- HashiCorp Terraform
- AWS Toolkit
- YAML
- GitLens

## 3. Install AWS CLI

### Step 1: Download AWS CLI
Download the latest AWS CLI v2 installer:  
[AWS CLI Downloads](https://aws.amazon.com/cli/)

### Step 2: Install AWS CLI
Run the MSI installer and complete the installation.

Alternative Installation Using PowerShell  
Run the following command in PowerShell:
```bash
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
```

### Step 3: Verify AWS CLI Installation
Open Command Prompt or PowerShell and run:
```bash
aws --version
```
Expected output:
```
aws-cli/2.x.x Python/3.x Windows/AMD64
```

## 4. Configure AWS CLI
Run the following command:
```bash
aws configure
```
Enter the following details:
- AWS Access Key ID
- AWS Secret Access Key
- Default region name
- Default output format

Example:
```
AWS Access Key ID [None]: AKIAXXXXXXXXXXXXX
AWS Secret Access Key [None]: XXXXXXXXXXXXXXXXXXXXX
Default region name [None]: ap-south-1
Default output format [None]: json
```

## 5. Verify Complete Setup
Run the following commands:

**Verify Terraform**
```bash
terraform -version
```

**Verify AWS CLI**
```bash
aws --version
```

**Verify AWS Authentication**
```bash
aws s3 ls
```
If configured correctly, it will display your S3 buckets.

## Recommended Folder Structure
```
terraform-projects/
├── project-1/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
└── project-2/
```

## Useful Terraform Commands

- **Initialize Terraform**
  ```bash
  terraform init
  ```

- **Validate Configuration**
  ```bash
  terraform validate
  ```

- **Preview Changes**
  ```bash
  terraform plan
  ```

- **Apply Infrastructure**
  ```bash
  terraform apply
  ```

- **Destroy Infrastructure**
  ```bash
  terraform destroy
  ```

## Additional Recommendations

- Install Git for version control.
- Use GitHub to store Terraform code.
- Never hardcode AWS credentials in .tf files.
- Use .gitignore to exclude sensitive files.

Example .gitignore:
```
.terraform/
*.tfstate
*.tfstate.backup
terraform.tfvars
```

## Useful Official Documentation

- [Terraform Documentation](https://www.terraform.io/docs/)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)
- [VS Code Documentation](https://code.visualstudio.com/docs)
.terraform/*.tfstate*.tfstate.backupterraform.tfvars

Useful Official Documentation


Terraform Documentation


AWS CLI Documentation


VS Code Documentation

