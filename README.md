# swyftx-assessment

## requirements
Terraform v1.0.8

## Configuration
Requires default profile in aws credentials setup using `aws config`.

## Deployment
cd ./terraform
terraform init
terraform apply -var-file input.tfvars

## Notes
If I didn't run out of time I would have liked to add another region and put a latency/geolocation based routing in front of those regions but alas.
