[![Build Status](https://travis-ci.org/ivanilves/xiringuito.svg?branch=master)](https://travis-ci.org/ivanilves/xiringuito)

# xiringuito

*SSH-based "VPN for poors"* :wink:

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
As long as your routes do not overlap, you can run as many `xiringuito` tunnels as you want. **Simultaneously!**

## xirin... WHAT?
"xiringuito" is a Catalan way of saying popular Spanish word "chiringuito", which usually means a beach bar in a more or less provisional building. As long as such places usually stand on a loose surface, operate without license and work only with cash, in urban dictionary "chiringuito" could mean any dodgy business, any activity of questional legality and confidence. I've picked up this name because I've wrote this as a quick temporary hack, partially in a bus, partially in a train, while travelling back and forth between job and home. But ... nothing is more permanent than the temporary, right? :smile:

<img src="xiringuito.png" width="256px" />

## Future?
Before, due to lack of testing, we had some complications with adding new features and changing xiringuito behavior, but since [this PR](https://github.com/ivanilves/xiringuito/pull/32) was merged, we are covered and will bravely proceed with addressing [issues](https://github.com/ivanilves/xiringuito/issues) and any challenges on our way. 
