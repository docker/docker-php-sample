# Docker PHP Sample

A simple PHP application containerized with Docker, using the official
`php:8.2-apache` image. Dependencies are managed with Composer.

## Project structure

```
docker-php-sample/
├── Dockerfile        # Single-stage build: PHP 8.2 + Apache + Composer deps
├── composer.json      # PHP dependency manifest
├── composer.lock       # Locked dependency versions
├── src/               # Application source code (web root)
├── tests/             # Test suite
└── README.md
```

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed and running
- Your user added to the `docker` group (or use `sudo` for Docker commands)
  ```bash
  sudo usermod -aG docker $USER
  newgrp docker
  ```

## Build the image

From the project root:

```bash
docker build -t php-app:latest .
```

This will:
1. Start from the `php:8.2-apache` base image
2. Copy the Composer binary in from the official `composer` image
3. Install PHP dependencies via `composer install`
4. Switch to production `php.ini` defaults
5. Copy in the application source from `src/`
6. Run the container as the non-root `www-data` user

## Run the container

```bash
docker run -d -p 9000:80 php-app:latest
```

- `-d` runs the container in the background (detached)
- `-p 9000:80` maps port `9000` on your host to port `80` inside the container

Check it's running:

```bash
docker ps
```

You should see something like:

```
PORTS
0.0.0.0:9000->80/tcp
```

## Access the app

Open in your browser:

```
http://localhost:9000/hello.php
```

Or, if running on a remote server (e.g. EC2), replace `localhost` with the
server's public IP, and make sure port `9000` is allowed in your firewall /
security group inbound rules.

## Stopping the container

```bash
docker ps                # find the container ID or name
docker stop <container>  # stop it
docker rm <container>    # remove it (optional)
```

## Rebuilding after code changes

Any time you change `src/`, `composer.json`, or the `Dockerfile` itself,
rebuild the image and restart the container:

```bash
docker build -t php-app:latest .
docker stop <container> && docker rm <container>
docker run -d -p 9000:80 php-app:latest
```

## Notes

- This Dockerfile is **single-stage** (no multi-stage build), so the final
  image includes Composer and its cache — larger than a multi-stage build,
  but simpler to read and doesn't require BuildKit.
- If you see `the --mount option requires BuildKit`, that means a
  Dockerfile is using BuildKit-only syntax (`RUN --mount=...`). Either
  enable BuildKit (`DOCKER_BUILDKIT=1 docker build ...`) or use the
  single-stage Dockerfile in this repo, which avoids that syntax entirely.
