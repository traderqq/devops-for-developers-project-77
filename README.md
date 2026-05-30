### Hexlet tests and linter status:
[![Actions Status](https://github.com/traderqq/devops-for-developers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/traderqq/devops-for-developers-project-77/actions)

## Devops Hexlet project #3
We will roll wikijs project to complex Yandex cloud setup - 2 vms, web load balancer and database cluster

yandex cloud instances and setup will be done automatically with Terraform

Wikijs rollout will be done with Ansible

Project is available here: [birchcapital.space](https://birchcapital.space)

### settings things up
make apply - create yandex cloud infrastructure and prepare servers

make provision-primary - roll-out wikijs to 1st vm (you need to go [here](https://birchcapital.space) and make initial setup before next step!)

make provision - create other vm (only after wikijs setup)
