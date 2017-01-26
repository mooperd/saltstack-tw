# Ansible Deployment

[Ansible](http://docs.ansible.com/) is a simple, agentless and powerful open source IT automation tool.

We have one `*.yml` configuration file per service.

We have different `hosts` files per environment (prod, staging, testing, dev)
as recommended in the [best practices](http://docs.ansible.com/ansible/playbooks_best_practices.html#staging-vs-production)

## How to deploy

````bash
ansible-playbook -i {ENVIRONMENT} {SERVICE}.yml
```

## Install

To run Ansible locally you can install it by running:
```bash
python2 -m pip install ansible
```

That securs a proper Ansible installation since Ansible is not available for Python 3.x 

