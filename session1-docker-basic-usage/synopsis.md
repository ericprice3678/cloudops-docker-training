# Synopsis
This is the first of 2 sessions on Docker usage. This session is going to mainly focus on basic Docker usage either locally or on GitPod.

Following this you will go from running a hello-world container to hosting a (very basic) nginx container.

## Process

### 1: Run the Docker hello-world container

1. Run `docker run  --name my-helloworld-container hello-world:latest`
    - This will pull and then execute the Docker hello-world container.
    - Your container image must be the last argument passed to this command.

### 2: Run a baseline nginx container locally

1. Run `docker pull nginx:latest`
2. Run `docker run --name my-nginx-container nginx:latest`
3. Connect to localhost in a web browser. This will return a `ERR_CONNECTION_REFUSED` because you have not mapped a traffic port to the container.
4. To fix this CMD+C to kill your running container and run `docker run -p 8080:80 --name my-nginx-container nginx:latest`. This will map the localhost port 8080 to port 80 on the container.=
5. Connect to localhost again. It will now show the default nginx landing page.

### 3. Running in Detached mode and viewing running containers.

In the previous example the docker container was run in the foreground, this is essentially running it as an active process. It is also possible to run Docker containers as a background process.

1. Run `docker run -d -p 8080:80 --name my-nginx-container nginx:latest`.
2. Now that this is running in detached mode you can view running containers status with the `docker ps` command.
3. You can also run `docker ps -a` which will also show stopped containers in addition to running containers.
4. You can use the `CONTAINER ID` of a container from `docker ps` to stop or kill the container with `docker stop $CONTAINER_ID` or `docker kill $CONTAINER_ID`.
    - The difference between these is that `stop` will issue a SIGTERM signal to the main process while `kill` will issue a SIGKILL signal.
5. To view active logs you can run `docker container logs $Container_ID`.
    - This will show whatever the console would output in foreground mode.
    - You can do this with a name instead of the container ID if desired
6. You can also use `docker exec` to execute commands on a running container.
    - e.g. run `docker exec -it my-nginx-container bash` to open an interactive bash shell on the container.

### 4. Building and running your own Nginx image

### 6. Building a container running Python & Flask

### 7. Layer Caching

### 8. Running apt-get

### 9. The DockerHub problem

### 10. DockerHub vs ECR Public Gallery vs ECR Private Repositories