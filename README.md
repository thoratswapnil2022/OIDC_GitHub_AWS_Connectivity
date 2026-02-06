# OIDC_GitHub_AWS_Connectivity

This repository demonstrates how to securely connect **GitHub Actions workflows to AWS** using **OpenID Connect (OIDC)** without storing long-lived AWS credentials in GitHub Secrets.

With OIDC, GitHub Actions can request short-lived AWS credentials dynamically — eliminating static access keys and improving security.

---

## 📌 What This Repository Contains

- 🔐 AWS IAM Role and Trust Policy setup (via Terraform)
- 🛠 GitHub Actions workflow that:
  - Assumes AWS IAM role using OIDC token
  - Retrieves temporary AWS credentials
  - Demonstrates AWS CLI access (e.g., S3, EC2 tests)
- 📁 Example IaC configuration under `/Terraform`
- 📁 Example GitHub Actions workflow under `.github/workflows`

---

## 🚀 Why OIDC with GitHub Actions?

Traditional pipelines often use AWS Access Keys stored as secrets — which can leak, expire, or require frequent rotation.

With **GitHub OIDC**:

- GitHub acts as Identity Provider (IdP)
- Workflows request short-lived JWT tokens
- AWS STS issues temporary credentials
- No hard-coded secrets required :contentReference[oaicite:1]{index=1}

Benefits:
✔ No AWS access keys in GitHub Secrets  
✔ Short-lived credential security  
✔ Least-privilege IAM access  
✔ Easier audit and rotation strategy

---

## 🛠 Setup Guide

### 1. Configure AWS OIDC Provider

In AWS IAM:
- Provider type: **OpenID Connect**
- Provider URL: `https://token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`

This allows AWS to trust OIDC tokens emitted by GitHub.

---

### 2. Create IAM Role for GitHub Actions

Configure trust policy to restrict access to your GitHub repository:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com" },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": { "token.actions.githubusercontent.com:aud": "sts.amazonaws.com" },
        "StringLike": { "token.actions.githubusercontent.com:sub": "repo:your-org/your-repo:*" }
      }
    }
  ]
}
Replace your-org/your-repo with your GitHub repo path.

### 3. Attach Appropriate IAM Permissions
In AWS, attach only required policies (least-privilege):

S3 access

EC2 describe

Lambda, EKS, etc.

Avoid broad policies like AdministratorAccess except for testing.

### 4. GitHub Actions Workflow
Example in .github/workflows/deploy.yml:

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::<ACCOUNT_ID>:role/YourOIDCRole
          aws-region: ap-south-1

      - name: Validate identity
        run: aws sts get-caller-identity

      - name: List S3 Buckets
        run: aws s3 ls
This workflow uses OIDC to authenticate and run AWS CLI commands.

### 5. 💡 How to Test
Push workflow to main branch

Check GitHub Actions logs

Confirm AWS CLI commands return expected output

Validate AWS IAM Role permissions

📚 Resources
GitHub Actions OIDC documentation 

AWS IAM OIDC setup guide 

aws-actions/configure-aws-credentials action docs 

👤 Contributors
Swapnil Thorat
