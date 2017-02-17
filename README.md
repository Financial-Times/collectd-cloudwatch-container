# collectd-cloudwatch-container

Docker image that collects Collectd metrics stored in /proc on host instance.

Currently uses version Collectd version 5.7.1.

### Table of Contents
**[Running container](#running-container)**  
**[Building Docker image](#Building-Docker-image)**  
**[Creating release](#creating-release)**  
**[Collectd commands](#collectd-commands)**  

![Architecture diagram](https://github.com/Financial-Times/collectd-cloudwatch-container/raw/master/monitoring-with-collectd-cloudwatch.png)

## Running container

Container must be started with the following parameters.

 * NAMESPACE (tld.domain.programme.environment.team)
   * Namespace is kind of a tag for metrics
   * Namespace should be unique and descriptive, eg. com.ft.universalpublising.test.semantic
 * MOUNTPOINT (-v /proc:/host/proc)
   * Mount host instance /proc directory inside the container's /host/proc directory

Example command

`docker run --env "NAMESPACE=com.ft.universalpublising.test.semantic" -v /proc:/host/proc -t coco/collectd-cloudwatch-container:latest`


## Building Docker image

Docker image is built by [Docker Hub](https://hub.docker.com/r/coco/collectd-cloudwatch-container/).

To build the _latest_ version simply push to [master branch](https://github.com/Financial-Times/collectd-cloudwatch-container/tree/master).

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
