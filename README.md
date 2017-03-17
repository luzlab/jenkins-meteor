We use this docker container for testing our meteor apps. It includes:

* Jenkins
* Node v4.8
* NPM v
* -- node-gyp (global)

To build the image for the first time `docker build -t studiofathom/jenkins-meteor .`

To push the image to the repository `docker push studiofathom/jenkins-meteor`.