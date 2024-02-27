# Installation

You only need one of the following installation options.
If you followed the Quickstart, you already have the Docker Hub version installed.

{{#include ../alpha-warning.md}}

## Installing from Docker Hub

There are two major release channels available:
stable and nightly.
To run the nightly builds, replace `endatabas/endb` with `endatabas/endb:nightly`
in the commands below.

If you run Docker, you can use the default command below.
`--rm` cleans up (optional), `-p` exposes the default `endb` port,
and `-v` mounts a local volume so your data persists even if you shut down the Docker image.

```sh
mkdir -p endb_data
docker pull endatabas/endb
docker run --rm -p 3803:3803 -v endb_data:/app/endb_data endatabas/endb
```

If you run Podman, you'll need to specify the `docker.io` repo explicitly:

```sh
mkdir -p endb_data
podman pull docker.io/endatabas/endb
podman run --rm -p 3803:3803 -v endb_data:/app/endb_data docker.io/endatabas/endb
```


## Installing from Git: Docker

If you want to run `endb` from the main branch, compile and build the Docker image:

* [https://github.com/endatabas/endb/#building](https://github.com/endatabas/endb/#building)
* [https://github.com/endatabas/endb/#docker](https://github.com/endatabas/endb/#docker)


## Installing from Git: Binary

If you don't want Docker at all, you can compile and run the `endb` binary:

* [https://github.com/endatabas/endb/#building](https://github.com/endatabas/endb/#building)
* `./target/endb`

NOTE: If you move the `endb` binary, be sure to copy `libendb.so` (Linux)
or `libendb.dylib` (MacOS) into the same directory.
This is because `endb` requires `libendb` to run.
