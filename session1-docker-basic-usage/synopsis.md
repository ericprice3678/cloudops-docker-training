# Synopsis
This is the first of 2 sessions on Docker usage. This session is going to mainly focus on basic Docker usage either locally or on GitPod.

Following this you will go from running a hello-world container to hosting a (very basic) nginx container.

## Process

### 1: Run the Docker hello-world container

1. Run `docker run  --name my-helloworld-container hello-world:latest`
    - This will pull and then execute the Docker hello-world container.
    - Your container image must be the last argument passed to this command.

### 2: Run an nginx container locally with the default configuration

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
    - You can do this with a name instead of the container ID if desired.
6. You can also use `docker exec` to execute commands on a running container.
    - e.g. run `docker exec -it my-nginx-container bash` to open an interactive bash shell on the container.

### 4. Run an nginx container with volume mapping

In this stage we will be using the `-v` flag to map the current local directory to a directory on the docker container.

1. Run `cd session1-docker-basic-usage`.
2. Run `docker run -p 8080:80 -v $(pwd):/usr/share/nginx/html:ro nginx:latest`. `pwd` in this case refers to the current directory.
    - This will append the contents of the current directory to `/usr/share/nginx/html`. Since the default index.html file used by nginx is in here it will overwrite it and use ours instead.
3. Connect to localhost. It should show a hello world page.

### 5. Building and running your own Nginx image

In the previous section we managed to display a custom page by replacing the default nginx landing page which is good for an example but isn't really how you should be hosting websites. The next stage is going to involve creating our own Docker image and configuring nginx to serve our hello world page rather than replacing the default page.

1. Review the contents of `nginx.conf` and `Dockerfile`. The Dockerfile is annotated with comments explaining exactly what each step is doing.
    - `nginx.conf` is the configuration file we will be using for nginx.
    - `Dockerfile` contains a list of instructions for how to build the container image.
2. Run `docker build --tag $yourname:nginx .`
    - It doesn't matter what you tag this if you're just running it locally. Tags do start to matter when you're dealing with pushing to image repositories but that is a Session 2 topic, just call it whatever you want.
    - The `.` at the end means "Use the Dockerfile in my current directory".
3. Run the image with `docker run -p 8080:80 $yourname:nginx`
4. Go to localhost. It should show a hello world page.

### 6. Layer Caching

Docker Layers are essentially each unique command issued by a Dockerfile. E.g. each unqiue COPY is its own layer.

In order to speed up builds Docker will cache layers locally by default. In essence once you've run each layer locally once you will have it cached so if it does not change inbetween builds your docker build will instead use the cached layer instead of running it again.

To see this in action:

1. Open `Dockerfile`.
2. Commend out `COPY index.html /www/data/index.html` and uncomment `COPY /layer-cache-example/cowbell.html /www/data/index.html`.
3. Re-run your `docker build` command.
4. You should see that the previously executed layers are built using the cache and the new copy COPY command is not.
5. Run the image with `docker run -p 8080:80 $yourname:nginx`
6. Go to localhost again, the site should have more cowbell in it now.

### 7. Entrypoints

Sometimes you may find yourself in a situation where you need to execute commands on a container after it is built, but before the application starts. You can do this by using an ENTRYPOINT command to execute a script that might set environment-specific information or perform some other command that the application needs before it tries to start.

An example of something to use an ENTRYPOINT for would be to programmatically retrieve values from Secrets Manager or Parameter Store.

As an example follow these steps to change the index.html file to be something else:

1. Open the `Dockerfile` and uncomment the `entrypoint-example` section.
2. Rebuild the image with `docker build --tag $yourname:nginx .`.
3. Run the new container image `docker run -p 8080:80 $yourname:nginx`.
4. Go to localhost again, the site should now have new content.

### 7. Installing multiple packages with apt-get

When installing multiple packages with apt-get you should:
1. Use noninteractive mode.
2. Use as few layers as possible.

e.g.

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    unzip \
    jq \
    libpq-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libbz2-dev \
    libzip-dev \
    libonig-dev \
    openssl \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    git \
    cron \
    && pecl channel-update pecl.php.net \
    && pecl install apcu \
    && pecl install redis \
    && docker-php-ext-enable redis

### 8. The DockerHub problem

A problem with using images from Dockerhub there are 2 main issues you may run into;

1. DockerHub API limits causing your builds to fail.
2. OS Kernel changes or package repository versions introducing issues in the downstream application.

To avoid this when you're working in real-world scenarios you should always pull down the Dockerhub image and push it into a private repository somewhere. Itoc has some IP that will do this with a private ECR repository: https://github.com/itoc/cloudops-shared/tree/main/ecr-base-image-pipeline

This a good default solution for this but you should use whatever is most suitable for your client.
