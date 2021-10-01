# dayzexp
#
# run dayz server in a docker container
echo "STEAMUSERNAME=anonymous" > .env
echo "PROFILEDIR=profile1" >> .env
echo "PORT0=2302" >> .env
# time docker-compose build --build-arg STEAMUSERNAME=anonymous --no-cache
docker-compose up --build

# shutdown container
docker-compose stop

# rebuild container
docker-compose stop
docker-compose build
docker-compose up -d

# config changes
vim profile1/serverDZ.cfg
docker-compose restart
