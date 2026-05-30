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

provision:
	ansible-galaxy collection install -r $(ANSIBLE_DIR)/requirements.yml
	ansible-playbook -i $(ANSIBLE_DIR)/inventory.ini $(ANSIBLE_DIR)/playbook.yml

provision-primary:
	ansible-galaxy collection install -r $(ANSIBLE_DIR)/requirements.yml
	ansible-playbook -i $(ANSIBLE_DIR)/inventory.ini $(ANSIBLE_DIR)/playbook.yml -e target_hosts=wikijs-web-1


deploy: apply provision
