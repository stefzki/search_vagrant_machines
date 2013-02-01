# Search Vagrant definitions

##Attention

This module is currently work in progress - i will remove this line when it is ready.

## Purpose

After i created the local test setup for MongoDB i recognized it would be great to have the possibility to evaluate other backend storage technologies as well. Therefore this repository contains search backend technologies like Elasticsearch.

## Preconditions

Please follow the install instructions at http://vagrantup.com/. Use the latest version from vagrant and install the latest version of VirtualBox (the version from the projects homepages are recommended). After the installation, verify that virtualization options are enabled in your bios, if you are using a 'normal' pc. I did not encounter any virtualization problems on macs. 

## The machines

### elasticsearch

This is a three instance setup for elasticsearch. It uses a standard Ubuntu base-box and installs elasticsearch via puppet. Furthermore elasticsearch will be configured to run on 0.0.0.0 and ports 9200 and 9300.

Usage:
``` 
cd elasticsearch
vagrant up
```

After this you can access elasticsearch by calling its http interfaces at:

- http://es01.local:9200/_cluster/status
- http://es02.local:9200/_cluster/status
- http://es03.local:9200/_cluster/status

To shut down the vagrant images use:

```
vagrant halt
```
or

```
vagrant destroy
```

## Evaluation proposal

To provide an easy to use evaluation tool, i created an db evaluation skeleton in Java - you can find it here https://github.com/strud/db_evaluation.