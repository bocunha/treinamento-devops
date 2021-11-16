#!/bin/bash

PWD="/home/ec2-user/treinamento-devops/spring-web"
SSHKEY=" ~/.ssh/ortaleb-chave-nova.pem"
echo  "Iniciar criacao das maquinas ..."
sleep 2

#terraform -chdir=$PWD/Terraform destroy -auto-approve
terraform -chdir=$PWD/Terraform init
terraform -chdir=$PWD/Terraform apply -auto-approve

echo  "Aguardando a criação das maquinas ..."
sleep 30

HOST_DNS=$(terraform -chdir=$PWD/Terraform output | awk -F"=" '/PUBLIC_DNS/{ sub("\",","",$2); print $2 }')

echo "
[ec2-java]
$HOST_DNS
" > $PWD/ansible/hosts

ansible-playbook -i $PWD/ansible/hosts $PWD/ansible/springweb.yml -u ubuntu --private-key $SSHKEY --ssh-extra-args='-o StrictHostKeyChecking=no'

echo  "Abrindo site no navegador"
sleep 10

echo "curl -L "http://${HOST_DNS}""
curl -L "http://${HOST_DNS}" | grep Admin

echo  "Acessando via SSH"
sleep 5
echo "ssh -i $SSHKEY ubuntu@$HOST_DNS -o ServerAliveInterval=60 -o StrictHostKeyChecking=no"
ssh -i $SSHKEY ubuntu@$HOST_DNS -o ServerAliveInterval=60 -o StrictHostKeyChecking=no