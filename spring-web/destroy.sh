#!/bin/bash

PWD="/home/ec2-user/treinamento-devops/spring-web"


terraform -chdir=$PWD/Terraform init
terraform -chdir=$PWD/Terraform destroy -auto-approve