\#Deployment Guide for the PureVibe Wellness Capstone project

\#Step 1: Go to the Actions tab of the frontend and backend API repo



\#Step 2: On the left side, you should see all the workflows

"Deploy to GCP, Snyk SAST/SCA/Container, and Terraform Plan"



\#Step 3: Make sure to add secrets before deploying

In GitHub:

Open your repository.
Click Settings.
Click Secrets and Variables.
Click Actions.
Click New Repository Secret.
Add your cloud credentials.

Example:

AWS\_ACCESS\_KEY\_ID
AWS\_SECRET\_ACCESS\_KEY

or

GOOGLE\_CREDENTIALS

depending on your cloud provider.



\#Step 4:
Go back to Actions tab and deploy one of the workflows

Workflow 1: Deploy to GCP > click on Run workflow > build & deploy jobs

Build expected result:

Set up job - Checked
Checkout Code - Checked
Authenticate to GCP - Checked
Set up Cloud SDK - Checked
Build Container - Checked
Post Authenticate to GCP via OIDC - Checked
Post Checkout code - Checked
Complete job - Checked

Deploy expected result:

Set up job - Checked
Checkout code - Checked
Authenticate to GCP via OIDC - Checked
Set up Cloud SDK - Checked
Configure Docker for Artifact Registry - Checked
Push Container - Checked
Deploy to Cloud Run - Checked
Show Live URL - Checked
Post Authenticate to GCP via OIDC - Checked
Post Checkout code - Checked
Complete job - Checked



Workflow 2: Snyk SAST/SCA/Container > Click on Run workflow > Snyk SAST/SCA/Container

Snyk SAST/SCA/Container expected result:

Set up job - Checked
Checkout code - Checked
Authenticate to GCP via OIDC - Checked
Fetch Snyk Secrets - Checked
Setup Snyk CLI - Checked
Snyk (SAST) Test - Checked
Snyk (SCA - Dependencies) Test - Checked
Build Container - Checked
Snyk Container Test - Checked
Post Authenticate to GCP via OIDC - Checked
Post Checkout code - Checked
Complete job - Checked


Workflow 3: Terraform Plan > Click on Run workflow > Plan VPC Infrastructure

Plan VPC Infrastructure expected result:

Set up job - Checked
Checkout code - Checked
Authenicate to GCP - Checked
Setup Terraform - Checked
Terraform Init - Checked
Terraform Validate - Checked
Terraform Format Check - Checked
Terraform Plan - Checked
Post Authenticate to GCP - Checked
Complete job - Checked
