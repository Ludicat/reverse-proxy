Local Docker reverse proxy
==========================

Start this container to benefit of all other projects been mounted through traefik reverse proxy.

    make start
  
stop it with

    make stop
    
Ubuntu
======
    
Install dnsmask
---------------

    sudo apt-get install dnsmasq
    
edit file `/etc/dnsmasq.conf` and update lines `local` and `address` with "test" tld:

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
