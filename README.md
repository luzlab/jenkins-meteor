We use this docker container for testing our meteor apps. It includes:

* Jenkins
* Node v4.8
* NPM v
* -- node-gyp (global)

To build the image `docker build -t studiofathom/jenkins-meteor:<TAG> .`
To push the image to the repository `docker push studiofathom/jenkins-meteor:<TAG>`.

Alternately, `./build.sh` handles building, tagging and conditionally pushing the image.
