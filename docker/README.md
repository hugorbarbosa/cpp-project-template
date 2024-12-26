# Docker image

This guide contains instructions for building and running the Docker image of this project.

For more information about the Docker tool and used commands, see this [Docker guide](https://github.com/hugorbarbosa/tutorials/blob/main/docker-guide/docker-guide.md).

## Table of contents

- [Build image](#build-image)
- [Run image](#run-image)

## Build image

Build Docker image using the following commands:

```sh
$ cd <project-directory>
$ cd docker
$ docker build . -t cppprojtempl
```

## Run image

Run image with creation of a container and mount the project (`<project-directory>` must have the absolute path, for example, c:\Projects\cpp-project-template):

```sh
$ docker run -it --name mycontainer -v <project-directory>:/src cppprojtempl
```

The project can now be compiled and run inside the container (project available in the `/src` directory), using the commands described [here](../README.md).
