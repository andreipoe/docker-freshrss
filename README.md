# docker-freshrss
This is a Docker image of [FreshRSS](https://github.com/FreshRSS/FreshRSS) based on [kokaz's work](https://github.com/kokaz/docker-freshrss). It has two main improvements over the original version:
 1. The version of FreshRSS to use can be easily specified at build time in the form of any git _treeish_. By default, the latest stable version is used, whereas the original Dockerfile used a pre-packaged, now outdated version.
 2. Following the [security advice in the FreshRSS README](https://github.com/FreshRSS/FreshRSS/tree/1.7.0#advices), only the public web folder is exposed, and not the full application installation.

## Usage

### Obtaining the image

You can download the image from the [Docker Hub](https://hub.docker.com/r/andreipoe/freshrss/):

    $ docker pull andreipoe/freshrss

Alternatively, you can clone the GitHub repository and build the image locally:

    $ git clone https://github.com/andreipoe/docker-freshrss.git
    $ cd docker-freshrss
    $ docker build -t freshrss . 
    
The top part of the Dockerfile contains a number of environment variables that you can set using the `-e` argument to `docker build`. The most useful one is `FRSS_VERSION`, which controls the version of FreshRSS used. For example, to run the latest development version of FreshRSS:

    $ docker build -t freshrss:dev -e FRSS_VERSION=dev
    
The remaining environment options only control the placement of files inside the container and should not need to be changed under normal usage.

### Running the image

The image exposes two volumes, one for the application data, and one for the logs. These are set to the values of the `$FRSS_DATA_DIR` and `$FRSS_LOG_DIR` environment varialbes, respecitvely. By default the following locations are used:
  * `/srv/FreshRSS/data` for the data
  * `/var/log/freshrss` for the logs

You don't need to mount the logs volume (logs will be deleted with the container), but you should mount the data volume to make your configuration persist accross container changes.

The image only exposes port `80` and runs FreshRSS withover http **only**. Thus, it is recommended to set up a reverse proxy with your own SSL certificate. _Hint: search for "nginx reverse proxy" and "let's encrypt"._

Below is a typical example of running the docker image:

    $ docker run -d --name FreshRSS --restart=unless-stopped -p 127.0.0.1:18880:80 -v /data/freshrss/data:/srv/FreshRSS/data -v /data/freshrss/logs:/var/log/freshrss andreipoe/freshrss

Then, set your reverse proxy to forward to `127.0.0.1:18880`.

### Initial set up

You are now ready to run FreshRSS. Point your browser to your domain name or IP address, and you should see the setup screen. _Please_ don't set up your admin account over plain http; make sure you have have a vaild TLS certificate and that it is being used.

The setup screen will walk you though creating the intial account (which will be the admin account) and the database. Note that this image does _not_ have a databse server inside, so either select SQLite, or connect it to an existing MySQL/MariaDB server. Before the set up is complete, FreshRSS will check that everything is configured properly, so do make sure that all the checkmarks are green before proceeding.

That's it! Add your favourite sources and start reading without machine learning, tracking, or other privacy-invading "features". 

## Issues

Trouble? Feature or improvement requests? Open [an issue](https://github.com/andreipoe/docker-freshrss/issues).

Interested to contribute back code? Submit [a pull request](https://github.com/andreipoe/docker-freshrss/pulls).

