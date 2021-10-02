# dayz experimental linux server in a docker container

## what this repository does for you

On startup the container checks if all server files are up to date and
downloads it via `steamcmd` if needed. This adds +45s to the container boot
time.

### initialization

To deploy this container you need to install `docker-compose`.

```bash
echo "STEAMUSERNAME=anonymous" > .env
echo "PROFILEDIR=profile1" >> .env
echo "PORT=2302" >> .env

# copy serverDZ.cfg, messages.xml from else where
# cp $SRC profile1/serverDZ.cfg
```

### container creation

When the container is build it installs steamcmd in an ubuntu environment and
installs all dependencies dayz server needs.

Currently, databases which save the games server state is not exported to the
host. You get a clean database (server wipe) on every container rebuild using
the `--no-cache` option.

```bash
# docker-compose build
```

For debugging use:

```bash
# time docker-compose build --build-arg STEAMUSERNAME=anonymous --no-cache
```

### starting

Before starting the container it copies the server configuration file and
`messages.xml` form the configured profile directory to the server file
installion directories.

```bash
docker-compose up -d
```

### shutdown container

```bash
docker-compose stop
```

### rebuild container

There is currently no way to re-read the configuration while a server is running.
You need to restart on every configurtion change.

```bash
docker-compose build
docker-compose up -d
```

You can do it one line also:

```bash
docker-compose up -d --build
```

A rebuild from scratch while running a server:

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

If the server is not working anymore and you need to restart without configuration changes:

```bash
docker-compose restart
```

## Features that might be implemented in the future

- multiple instance_ids
- mod support
