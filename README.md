CIS 410 — Capstone Frontend

Expected result after terraform apply

```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

tf_state_bucket_name = "cis410-yourname-tfstate"
tf_state_bucket_url  = "gs://cis410-yourname-tfstate"
logs_bucket_name     = "cis410-yourname-logs"
logs_bucket_url      = "gs://cis410-yourname-logs"
project_id           = "cis410-yourname-xxxx"
```

Both buckets will appear in GCP Console → Cloud Storage → Buckets.
Quick start

```bash
# 1. Copy into your repo
cp -r terraform/ ~/cis-410-cybersecurity-automation/

# 2. Set your Project ID
cd ~/cis-410-cybersecurity-automation/terraform/week6
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars — replace cis410-yourname-xxxx with your actual Project ID

# 3. Run the workflow
terraform init
terraform plan    # should show: 2 to add
terraform apply   # type yes
terraform destroy # type yes
terraform apply   # recreate — Destroy and Rebuild principle

# 4. Commit (NOT tfvars or tfstate)
git add terraform/app/main.tf
git add terraform/app/variables.tf
git add terraform/app/outputs.tf
git add terraform/app/.terraform.lock.hcl
git commit -m "Week 1: GCS buckets — tfstate + logs"
git push origin main
```

.gitignore additions
Add these to your repo root `.gitignore`:

```
.terraform/
*.tfvars
*.tfstate
*.tfstate.backup
```

Runner VM: pawan-runner

Runner IP: 192.168.1.131 #fake ip

Pipeline status: [![Hello Pipeline](https://github.com/d33p-007/cis-410-cybersecurity-automation/actions/workflows/hello-pipeline.yml/badge.svg)](https://github.com/d33p-007/cis-410-cybersecurity-automation/actions/workflows/hello-pipeline.yml)

## Company Name

- PureVibe Wellness --

## App Description

#-- Users can register/log in and create their profile. They can look for a healthy diet plan for themselves and their family members. Users can also learn about fitness exercises they can do at home, such as yoga or stretching.


## Team Members & Roles

-#-- Project Lead - Pawan Mehra
GitHub Username: d33p-007
#-- Backend Engineer - Tre Crowley
GitHub Username: trecrowley
#-- Frontend Engineer - Ruweda Hassan
GitHub Username: Ruru489
#-- DevSecOps Engineer - Seth Richardson
GitHub Username: Srichardson00
#-- Security Reviewer - Wesley Ngem
GitHub Username: cyberwes69
