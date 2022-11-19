# Useful docker commands

Build image:

```sh
$ docker build . -t <image_name>
```

List images:

```sh
$ docker images
```

Remove image:

```sh
$ docker rmi <image_name>
```

Run container:

```sh
$ # Create without naming container
$ docker run -it <image_name>
$ # Create with naming container
$ docker run -it --name <container_name> <image_name>
$ # Create and remove container in the end
$ docker run -it --rm <image_name>
$ # Create and mount
$ docker run -it --name <container_name> -v <source>:<target> <image_name>
```

List containers:

```sh
$ docker ps -a
```

Start container:

```sh
$ docker start -i <container_name>
```

Stop container:

```sh
$ docker stop <container_name>
```

Execute a command inside of container:

```sh
$ docker exec -it <container_name> <command>
```

Remove container:

```sh
$ docker rm <container_name>
```
