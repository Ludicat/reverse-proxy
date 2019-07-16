Local Docker reverse proxy
==========================

Before first run you should run 

    make build

Start this container to benefit of all other projects been mounted through traefik reverse proxy.

    make start
  
stop it with

    make stop
    
To get an overview of running containers, go to [Traefik dashboard](http://traefik.dnx.test/dashboard/)
    
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
    
### If it's resolved:

Edit `/etc/systemd/resolved.conf` and uncomment

    DNSStubListener=no

Then restart resolved and dnsmask

    sudo service systemd-resolved restart
    sudo service dnsmasq restart

Be careful if you setup dnsmask the wrong you'll lost internet DNS resolution.
Just revert the changes should fix it.
