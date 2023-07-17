#!/bin/bash
 
docker login repo.appmodule.net:5050 --username proxy-deploy-token --password-stdin < ./tokens/.proxy-deploy-token
 
 
# update plugins
cd /opt/siot/plugin-spawner/plugins
echo "Pulling plugin repo changes"
for D in `find . -maxdepth 1 -mindepth 1 -type d`
do
    cd "$D"
    echo "Pulling changes for $D"
    git reset --hard
    git pull
    cd ..
done
echo "Finished pulling plugin repo changes"
 
cd /opt/siot/plugin-spawner/
docker-compose down --remove-orphans
 
# update  repo contents
git reset --hard
git pull
git rm -rfq .
git checkout master -- docker-compose.yml compose-files
 
# pull new images and start up
docker-compose pull
docker-compose up -d
docker logout repo.appmodule.com:5050
