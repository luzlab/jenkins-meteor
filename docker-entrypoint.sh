#!/usr/bin/env bash
# Based on http://vitorbaptista.com/how-to-access-hosts-docker-socket-without-root

DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GROUP=docker
REGULAR_USER=jenkins

if [ `getent group ${DOCKER_GROUP}` ]; then
  echo "Group 'docker' already exists. Starting Jenkins normally."
  su ${REGULAR_USER} -c "/bin/tini -- /usr/local/bin/jenkins.sh ${@}"
else
  if [ -S ${DOCKER_SOCKET} ]; then
    echo "Creating 'docker' group and adding 'jenkins' user."
    DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})
    groupadd -for -g ${DOCKER_GID} ${DOCKER_GROUP}
    usermod -aG ${DOCKER_GROUP} ${REGULAR_USER}

    echo "Success! Starting Jenkins normally."
  else
    echo "Couldn't find the docker socket to the parent."
    echo "Did you create the image with '--volume /var/run/docker.sock:/var/run/docker.sock'?"
  fi
fi

# Change to regular user and run the rest of the entry point from the
# parent Jenkins container Dockerfile https://github.com/jenkinsci/docker/blob/master/Dockerfile

gosu ${REGULAR_USER} /bin/tini -- /usr/local/bin/jenkins.sh ${@}
