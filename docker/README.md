# Docker guide

This guide contains instructions for building and running the docker image of this project.

For more information about the used docker commands, see [this file](./docker-commands.md).

## Table of contents

- [Build image](#build-image)
- [Run image](#run-image)

## Build image

Build docker image using the following commands:

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
