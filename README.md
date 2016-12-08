Ruby Node.js container
====================

> In this Dockerfile by using the ndenv you have installed the Node.js
> The following package has already been installed together
> phantomjs, libsass, node-sass

Installation
-----

The easiest way to do this is to get from Docker registry

```sh
$ docker pull kazu69/node:7.2.0-debian
```

Also possible to use or from github to get

```sh
$ git clone https://github.com/kazu69/docker-node.git
$ cd docker-node
$ git branch 7.2.0-debian
$ docker build -t kazu69/docker-node .
```