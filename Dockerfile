FROM jenkins/jenkins:lts
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
	wget \
  python-dev \
  python-pip

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
	apt-get update && apt-get install -y google-chrome-stable

# This script will install the Meteor binary installer (called the launchpad) in /usr/local
# and consequently requires to be root. Then, when we will run the "meteor" command later on
# for the first time, it will call the launchpad that will copy the Meteor binaries in ~/.meteor.
# This way every user can run Meteor under the user space.
RUN curl https://install.meteor.com | /bin/sh

# Install the AWS CLI tools
RUN pip install --upgrade pip
RUN pip install --upgrade virtualenv
RUN pip install awscli

# Set locale (needed to start MongoDB)
RUN echo "America/Los_Angeles" > /etc/timezone && \
    ln -fs /usr/share/zoneinfo/`cat /etc/timezone` /etc/localtime && \
    dpkg-reconfigure --frontend=noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LC_ALL=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Set the timezone
ENV JENKINS_JAVA_OPTIONS "-Duser.timezone=America/Los_Angeles"

# Install deps for FATHOM software
RUN apt-get install -y \
  libsasl2-dev \
  pkg-config \
  liblz4-dev \
  openssl \
  libssl-dev \
  zlib1g-dev

# Install docker
RUN apt-get install -y docker

# Switch to the regular user (as specified in the 'jenkins' container) so
# jenkins doesn't run as `root`
USER jenkins
