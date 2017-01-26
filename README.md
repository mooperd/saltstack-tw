DCMN Deployment
===============

This repository is used for deploying servers and applications using [SaltStack](http://saltstack.com/)

We are adopting a microservices architecture which means instead of shipping with one big and complex system
we are going to compose it into smaller, independent services. These services are highly decoupled and will
get it's one version by facilitating a modular approach to system-building. 

Instances will be named as follows:
  * AWS Production:  `{service}-prod-{number}`
  * AWS Staging:     `{service}-staging-{number}`
  * AWS Development: `{service}-dev-{number}`
  * Local:           `{service}-dev-local`


Development (Local):
--------------------

For setting up a local development environment you need [Vagrant](https://www.vagrantup.com/)
as well as [VirtualBox](https://www.virtualbox.org/).

To start your development environment go into the root directory of this repository and run
`vagrant up {service}` (e.g. `vagrant up piwik`).

But wait if you setup the deployment the first time or if you need to setup a new service you need also check
the following:

The directory structure needs to be:
```
[...]/deployment/         <- The deployment repository
[...]/deployment/pillar/  <- Configuration files
[...]/service1/           <- This is your first service (e.g. piwik) that needs to be deployed
[...]/serviceN/           <- This is another service that needs to be deployed (e.g. api)
```

The `[...]/deployment/pillar/` folder contains configuration files that are required by deploying
instances or required by the services to run.

There are some files named `*.dist.sls` which marks a file as a template that needs to be copied to
`*.sls` or `*-dev.sls` (depending on what this file is for) and edit the template for your needs.

The `*.dist.sls` files are part of the repository but the copied files are listed in `.gitignore`
to make sure passwords, keys etc. are not commited.

Good luck ;)


Development (AWS):
------------------

Be aware that currently we have one salt-master for both staging and production networks. Treat the salt-master as a PRODUCTION system when using it to deploy staging instances.

Staging:
--------

Deploying instances into the staging/testing subnet is quite simple.
```
salt-cloud -p centos7_ec2_t2_medium_Staging_Int_A <service-staging-000>
```

This will produce some output and in the end you will see a chunk of YAML describing the instance that you've just deployed. We can now configure this machine. You might want to add a timeout to this command as the default of 30s can be too little. Even if the connection times out the job will continue to run on the minion.
```
salt 'service-staging-000' state.highstate -t300
```

Removing these instances is also quite simple
```
salt-cloud -d service-staging-000
```

If we look into the location /etc/salt/cloud.profiles we can see the different instance profiles that are available. Take care to use the right profile ```centos7_ec2_t2_medium_Staging_Int_A``` to deploy into the staging/testing subnet. 

The instance name you choose should reflect that its in the staging subnet. for instance ```piwik-staging-054```. You can choose a number at random apart from 666. This is the number of the beast and we would risk opening a portal into the underworld which is quite expensive on AWS.

_Some other useful commands_

Salt-key will return information about which hosts are currently being managed by salt. Bear in mind that machines that have been destroyed in the AWS console or by demons from the underworld will still be visible in this list.
```
salt-key
```

test.ping will show us which salt-minions can be connected from the salt-master. This can be useful for debugging connection problems.
```
salt '*' test.ping
```

For instance; We can see from this output that one of the hosts (```piwik-prod-045```) is not responding. This is because this host was destroyed in the AWS console.

```
[root@master centos]# salt '*' test.ping
piwik-prod-046:
    True
piwik-prod-082:
    True
piwik-staging-025:
    True
tracktor-testing-154:
    True
tracktor-prod-b-022:
    True
freeipa-prod-b-032:
    True
master:
    True
freeipa-prod-a-031:
    True
control-prod-043:
    True
celery-testing-045:
    True
tracktor-prod-a-021:
    True
piwik-prod-045:
    Minion did not return. [Not connected]
```


Production:
-----------
Deploying production machines is the same at above but a deeper understanding of the infrastructure is required.

