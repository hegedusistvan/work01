# HELP
# This will output the help for each task
.PHONY: help ssh_keygen create_dir_opt_data docker_pull docker_build_image docker_build_containers build run up ansible ssh-alpha ssh-bravo ssh-charlie

help: ## Show help messages
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# PREREQUISITES TASK
ssh_keygen: ## Generate ssh keys for the ansible user
	cd ./ssh-keys && if [[ ! -e "./ansible_id_rsa" ]]; then ssh-keygen -b 4096 -t rsa -N "" -f ansible_id_rsa; fi

create_dir_opt_data: ## Create mapping directory for Charlie's /opt/data
	if [[ ! -d "/tmp/charlie-opt-data" ]]; then mkdir /tmp/charlie-opt-data; fi

# DOCKER TASKS

docker_pull: ## Pull the base Docker Image
	docker pull ubuntu:20.04

docker_build_image: ## Build the Docker Image
	cp ./ssh-keys/ansible_id_rsa.pub ./docker/
	cd ./docker && docker image build --network=host -t conti-test:1.0 .

docker_build_containers: ## Build the Docker Containers

build: docker_pull docker_build_image docker_build_containers ## Pull the base Docker Image and build the Docker Image and Containers

run: ## Run the Docker Containers
	cd ./docker-compose && docker-compose up -d

up: ssh_keygen create_dir_opt_data build run ## Bring up the Docker Containers

down: ## Switch off the Docker Containers
	cd ./docker-compose && docker-compose down

status: ## Status of the Docker Containers
	cd ./docker-compose && docker-compose ps

# ANSIBLE TASKS
ansible: ## Run Ansible playbook - Provision
	cd ansible && ansible-playbook -i ./inventory/hosts.yml -u ansible --private-key ../ssh-keys/ansible_id_rsa playbook-provision.yml

ssh-alpha: ## SSH to host - alpha
	ssh -i ./ssh-keys/ansible_id_rsa ansible@172.16.100.140

ssh-bravo: ## SSH to host - bravo
	ssh -i ./ssh-keys/ansible_id_rsa ansible@172.16.100.141

ssh-charlie: ## SSH to host - chalie
	ssh -i ./ssh-keys/ansible_id_rsa ansible@172.16.100.142
