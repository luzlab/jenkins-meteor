FROM jenkins
MAINTAINER Carlo Quinonez <carlo@studiofathom.com>

USER root

# Build tools for rebuilding binary npm packages and headless testing
RUN apt-get update && apt-get install -y \
	build-essential \
	g++ \
	python \
	chromedriver \
	xvfb \
	locales \
	curl \
	wget

# Install the right version of NODE and NPM
RUN curl -sL https://deb.nodesource.com/setup_4.x | /bin/bash - && \
	apt-get install -y nodejs && \
	npm update -g npm
RUN npm install -g node-gyp

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
	apt-get update && apt-get install -y google-chrome-stable

# This script will install the Meteor binary installer (called the launchpad) in /usr/local
# and consequently requires to be root. Then, when we will run the "meteor" command later on
# for the first time, it will call the launchpad that will copy the Meteor binaries in ~/.meteor.
# This way every user can run Meteor under the user space.
RUN curl https://install.meteor.com | /bin/sh

# Set locale (needed to start MongoDB)
RUN echo "America/Los_Angeles" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LC_ALL=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Set the timezone
ENV JENKINS_JAVA_OPTIONS "-Duser.timezone=America/Los_Angeles"

