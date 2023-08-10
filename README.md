# Terraform-with-GCP
> Deploy a static website to Google Cloud Storage using IaC with Terraform.


# Architecture

![Personal visualization - terraform-html](https://github.com/HikariJadeEmpire/Terraform-with-GCP/assets/118663358/1f484ab7-e078-4728-abf9-c80418548822)

<br>

## Details

**To perform this project :** [CLICK!](https://www.youtube.com/watch?v=VCayKl82Lt8) <br>
**SOURCE :** [CLICK!](https://github.com/rishabkumar7/freecodecamp-terraform-with-gcp) <br>

**Prerequisite** : <br>
- GCP Account
- Terraform installed
- Domain name
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) installed and authenticated

<br>

Enable the following APIs : <br>
- Cloud DNS API
- Compute Engine API
- Identity and Access Management (IAM) API

<br>

Create Servies Account : <br>

```python
GCP : IAM and admin >>> Service accounts >>> Create service account

# After creating the service account, create a key

Your service account >>> KEYS >>> ADD KEY >>> CREATE NEW KEY >>> JSON

# In Terraform, you can use .tfvars files to store your credentials instead of .tf files

```

# HTML Example

![Capture](https://github.com/HikariJadeEmpire/Terraform-with-GCP/assets/118663358/648558ce-69c0-4276-9c2f-1a4606a462aa)

<br>

To access your website : <br>

```Terraform

website.${data.google_dns_managed_zone.dns_zone.dns_name}/index.html

```
