#!/bin/bash
set -x
AWS_REGION="eu-west-3"

ARTIFACT=`packer build -machine-readable packer-demo.json | awk -F, '$0 ~/artifact,0,id/ {print $6}'`
echo "packer output:"
cat packer-demo.json

AMI_ID=`echo $ARTIFACT | cut -d ':' -f2`
echo "AMI ID: ${AMI_ID}"

echo "writing amivar.tf and uploading it to s3"
echo 'variable "APP_INSTANCE_AMI" { default = "'${AMI_ID}'" }' > amivar.tf
aws s3 cp amivar.tf s3://terraform-state-f8nbmg9m/amivar.tf --region $AWS_REGION
aws s3 cp amivar.tf s3://terraform-state-f8nbmg8m/amivar.tf --region $AWS_REGION
