# collectd-cloudwatch-container

Docker image that collects Collectd metrics stored in /proc on host instance.

Currently uses version Collectd version 5.7.1.

### Table of Contents
**[Running container](#running-container)**  
**[Building Docker image](#building-docker-image)**  
**[Creating release](#creating-release)**  
**[Collectd commands](#collectd-commands)**  
**[Credits](#credits)**  
**[Contact info](#contact-info)**  

![Architecture diagram](https://github.com/Financial-Times/collectd-cloudwatch-container/raw/master/monitoring-with-collectd-cloudwatch.png)

## Running container

Container must be started with the following parameters.

 * NAMESPACE (tld.domain.programme.environment.team)
   * Namespace is kind of a tag for metrics
   * Namespace should be unique and descriptive, eg. com.ft.universalpublising.test.semantic
 * INSTANCEID
   * EC2 instance ID is used to identify the host alert relates to, eg. i-0a4622c20cb792c1f
 * TOPIC
   * Optional parameter that enables email alerts to be sent to specific SNS Topic
   * Format of the topic is _arn:aws:sns:region:accountnumber:TopicName_
   * Topic can be set per environment by storing topic name under key [/ft/config/sns_topic_arn](https://github.com/Financial-Times/up-neo4j-service-files/blob/3dde1b30c18cab6652d9c726073fe84bc2be0410/collectd-cloudwatch-container.service#L22) in etcd
 * CONFIG
   * Optional parameter to override default alarms configuration file alarms.yml (in current working directory)
   * Value can either be a path to a [YAML configuration file](https://github.com/Financial-Times/collective/blob/master/cloudwatch-alarms/alarms.yml) or a URL to HTTP endpoint that contains YAML configuration file for alarms
 * MOUNTPOINT (-v /proc:/host/proc)
   * Mount host instance /proc directory inside the container's /host/proc directory

Example command

```
docker run \
--env "NAMESPACE=com.ft.universalpublising.test.semantic" \
--env "INSTANCEID=$(curl -s --connect-timeout 3 http://169.254.169.254/latest/meta-data/instance-id)" \
--env "TOPIC=arn:aws:sns:region:accountnumber:TopicName" \
--env "CONFIG=config/prod-us-alarms.yml" \
-v /proc:/host/proc -t coco/collectd-cloudwatch-container:latest
```


## Building Docker image

Docker image is built by [Docker Hub](https://hub.docker.com/r/coco/collectd-cloudwatch-container/).

Building from [master branch](https://github.com/Financial-Times/collectd-cloudwatch-container/tree/master) has been disabled.

To build image from master you must do this locally. Here is example command in local environment.
```
~/collectd-cloudwatch-container $(master) sudo docker build -t collectd-cloudwatch-container:local .
```

### Creating release

To release a version create a tag with version number and push it to remote. Docker Hub will build a image with version number same as the tag name.

```
~/collectd-cloudwatch-container $(master) git tag v1.0.0
~/collectd-cloudwatch-container $(master) git tag -l
v1.0.0
~/collectd-cloudwatch-container $(master) git push origin v1.0.0
Total 0 (delta 0), reused 0 (delta 0)
To git@github.com:Financial-Times/collectd-cloudwatch-container.git
 * [new tag]         v1.0.0 -> v1.0.0

```



## Collectd commands

```
bash-4.3# collectd -h
Usage: collectd [OPTIONS]

Available options:
  General:
    -C <file>       Configuration file.
                    Default: /etc/collectd/collectd.conf
    -t              Test config and exit.
    -T              Test plugin read and exit.
    -P <file>       PID-file.
                    Default: /var/run/collectd.pid
    -f              Don't fork to the background.
    -h              Display help (this message)

Builtin defaults:
  Config file       /etc/collectd/collectd.conf
  PID file          /var/run/collectd.pid
  Plugin directory  /usr/lib/collectd
  Data directory    /var/lib/collectd

collectd 5.7.1, http://collectd.org/
by Florian octo Forster <octo@collectd.org>
for contributions see `AUTHORS'
```


## Credits

The implementation has been heavily influenced by [rightscale/collectd-container](https://github.com/rightscale/collectd-container) project. Thank you for sharing the idea with general public.

## Contact info

Curent maintainer: Jussi Heinonen <jussi.heinonen@ft.com>
