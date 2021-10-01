# dayzexp

## run dayz server in a docker container

```bash
echo "STEAMUSERNAME=anonymous" > .env
echo "PROFILEDIR=profile1" >> .env
echo "PORT0=2302" >> .env
# copy serverDZ.cfg from else where
# cp $SRC profile1/serverDZ.cfg

# time docker-compose build --build-arg STEAMUSERNAME=anonymous --no-cache
docker-compose up --build
```

## shutdown container

```bash
docker-compose stop
```

## rebuild container

```bash
docker-compose stop
docker-compose build
docker-compose up -d
```

## config changes

```bash
vim profile1/serverDZ.cfg
docker-compose build
docker-compose up -d
```

