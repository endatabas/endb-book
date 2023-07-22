# Installation

At this stage, Endatabas is highly experimental.
We do not push images to Docker Hub often.
We recommend building the local Docker image if you want a recent version.

## Installing from Docker Hub

If you run Docker:

```sh
docker pull endatabas/endb
docker run endatabas/endb
```

If you run Podman:

```sh
podman pull docker.io/endatabas/endb
podman run docker.io/endatabas/endb
```


## Installing from Git: Docker

Compile `endb` and build the Docker image:

* https://github.com/endatabas/endb/#building
* https://github.com/endatabas/endb/#docker


## Installing from Git: Binary

Compile and run the `endb` binary:

* https://github.com/endatabas/endb/#building
* `./target/endb`
