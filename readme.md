[![tfsec](https://github.com/gordonmurray/terraform_webserver/actions/workflows/tfsec-analysis.yml/badge.svg)](https://github.com/gordonmurray/terraform_webserver/actions/workflows/tfsec-analysis.yml)

# Using Terraform to create a simple Webserver on AWS

### Cost

Powered by Infracost.

```
 Name                                                 Monthly Qty  Unit   Monthly Cost

 aws_instance.example
 ├─ Instance usage (Linux/UNIX, on-demand, t3.micro)          730  hours         $8.32
 └─ root_block_device
    └─ Storage (general purpose SSD, gp2)                      10  GB            $1.10

 OVERALL TOTAL                                                                   $9.42
 ```