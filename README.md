# xiringuito

*SSH-based VPN for poors* :wink:

VPN made easy! No configuration. No VPN servers. No hassle. **Just plug and use!**

This is the "VPN without VPN" software done using nice built-in capabilities of SSH.

### Install (just download it)
```
git clone https://github.com/ivanilves/xiringuito.git
```

### Use (just run it)
```
cd xiringuito
./xiringuito user@your.ssh.server 10.0.0.0/8 192.168.0.0/16
```
Yes! That easy - just pass an SSH server and the list of networks your want to access through this server.

You will need:
* Linux or Mac system
* Local sudo privileges
* Remote sudo privileges

## Mac note
Install [TunTap for Mac OS X](http://tuntaposx.sourceforge.net/) first.

## Route discovery
Specifiying routes by hand is not bad. But we could make it better by creating an executable `discover-routes` script in the project directory. If no routes are passed by hand, `xiringuito` will run `discover-routes`, pass SSH server hostname to it and use script output as a list of routes, so you may have per-host or per-domain route lists instead of boring manual typing. More information is available in [AWS example](https://github.com/ivanilves/xiringuito/blob/master/discover-routes.aws.example) which uses AWS CLI to discover VPC subnets and route traffic to them through our VPN tunnel.

## You can have many of them!
As long as your routes do not overlap, you can run as many `xiringuito` tunnels as you want. Simultaneously.
