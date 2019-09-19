Local Docker reverse proxy
==========================

This reverse proxy is a docker-compose configuration.
So you needs a valid docker-compose setup before using this container. 

Create config file
------------------

Copy `.env.dist` to `.env`

Open it with any text editor and update the file with your parameters.

    ###> docker-compose ###
    # Check that it's not aleady in use. "test" is a safe TLD, "dev" is not
    DOCKER_TLD=test
    # can be either "no" or "always" to auto start on computer startup
    DOCKER_RESTART=always
    ###< docker-compose ###

Copy `traefik.toml.dist` to `traefik.toml`. To update it, please refers to [Traefik officiel documentation](https://docs.traefik.io/v1.0/toml/)

Build and run docker
--------------------

Before first run and after config update you should run 

    make build

Start this container to benefit of all other projects been mounted through traefik reverse proxy.

    make start
  
stop it with

    make stop
    
Restart it with

    make restart
    
Other commands are available with `make help`
    
To get an overview of running containers, go to [Traefik dashboard](http://traefik.test/dashboard/)
    
Ubuntu
======
    
Install dnsmask
---------------

    sudo apt-get install dnsmasq
    
edit file `/etc/dnsmasq.conf` and update lines `server` (to define intenet DNS) `local` and `address` with "test" tld:

    # Add other name servers here, with domain specs if they are for
    # non-public domains.
    # Google DNS, alternatives here https://servers.opennicproject.org/
    server=8.8.8.8
    server=8.8.4.4

    # Add local-only domains here, queries in these domains are answered
    # from /etc/hosts or DHCP only.
    local=/test/
    
    # Add domains which you want to force to an IP address here.
    # The example below send any host in double-click.net to a local
    # web-server.
    address=/test/127.0.0.1


Avoid conflict on port 53
=========================

Check what's listening on port 53
---------------------------------

    sudo lsof -Pn +M | grep ':53 (LISTEN)'
    
### If it's `resolved`:

Edit `/etc/systemd/resolved.conf` and uncomment

    DNSStubListener=no

Then restart both resolved and dnsmask

    sudo service systemd-resolved restart
    sudo service dnsmasq restart

Be careful if you setup dnsmask the wrong way you'll lost internet DNS resolution.
Just revert the changes should fix it.

Usage
=====

Start the container once, if you set restart as always it should restart with your computer.

You needs to create a private network for your project. Purpose is to connect project container but not expose the ones
that don't have to, like databases.

In you docker compose files, just add labels like described in [Traefik container documentation](https://docs.traefik.io/v1.5/configuration/backends/docker/#on-containers)
then start them.

Check the sample file for basic php container setup [here](doc/docker-compose.yml).

Last word
=========

- It's NOT a production ready container, it have never been tested in such environment. Purpose is to have an easy setup for dev env.
- I had difficulties making https works (only by accessing container by direct ip:port). https label didn't worked for me, certainly a traefik.toml issue. If any of you have an idea or method to resolve, feel free to submit a merge request (even to update this documentation).
