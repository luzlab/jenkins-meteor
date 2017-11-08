#/bin/sh -

DOCKER_IMAGE='studiofathom/jenkins-meteor'
NEXT_TAG=`curl -s https://registry.hub.docker.com/v2/repositories/$DOCKER_IMAGE/tags/ | jq '[."results"[]["name"]|tonumber] | max + 1'`

echo "Building $DOCKER_IMAGE:$NEXT_TAG"

docker build -t $DOCKER_IMAGE:$NEXT_TAG .

while true; do
    read -p "Do you wish to push this image?" yn
    case $yn in
        [Yy]* ) docker push $DOCKER_IMAGE:$NEXT_TAG; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
