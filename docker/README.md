# Docker image

This guide contains instructions for building and running the Docker image of this project.

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

Run image creating a container and mounting the project (`<project-directory>` must have the absolute path, e.g., c:\Projects\cpp-project-template on Windows or /home/user/projects/cpp-project-template on Linux):

```sh
$ docker run -it --name mycontainer -v <project-directory>:/src cppprojtempl
```

The project will be available in the `/src` directory of the container.
