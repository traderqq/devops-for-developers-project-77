TF_DIR = terraform
ANSIBLE_DIR = ansible

.PHONY: init fmt validate plan apply destroy output provision deploy

init:
	cd $(TF_DIR) && ./tf.sh init

fmt:
	cd $(TF_DIR) && terraform fmt -recursive

validate:
	cd $(TF_DIR) && ./tf.sh validate

plan:
	cd $(TF_DIR) && ./tf.sh plan

apply:
	cd $(TF_DIR) && ./tf.sh apply

destroy:
	cd $(TF_DIR) && ./tf.sh destroy

output:
	cd $(TF_DIR) && ./tf.sh output

provision-primary:
	ansible-galaxy collection install community.docker
	ansible-playbook -i $(ANSIBLE_DIR)/inventory.ini $(ANSIBLE_DIR)/playbook.yml -e target_hosts=wikijs-web-1

provision:
	ansible-galaxy collection install community.docker
	ansible-playbook -i $(ANSIBLE_DIR)/inventory.ini $(ANSIBLE_DIR)/playbook.yml

deploy: apply provision
