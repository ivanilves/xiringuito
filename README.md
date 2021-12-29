[![Build Status](https://travis-ci.org/ivanilves/xiringuito.svg?branch=master)](https://travis-ci.org/ivanilves/xiringuito)

# xiringuito

*SSH-based "VPN for poors"* :wink:

VPN made easy! No configuration. No VPN servers. No hassle. **Just plug and use!**

This is the "VPN without VPN" software done using nice built-in capabilities of SSH.

### Install (just download it)
```
git clone https://github.com/ivanilves/xiringuito.git
```

### Use (just run it ...)
```
cd xiringuito
./xiringuito user@your.ssh.server 10.0.0.0/8 192.168.0.0/16
```
... or install it globally and run from any working directory:
```
cd xiringuito
sudo make install
xiringuito user@your.ssh.server 10.0.0.0/8 192.168.0.0/16
```

Yes! That easy - just pass an SSH server and the list of networks your want to access through this server.

You will need:
* Linux or Mac system
* Local sudo privileges
* Remote sudo privileges

## Xaval: connection manager
**NB!** To ease xiringuito configuration, `xaval` connection manager (script inside the project) could be used.
<img src="images/install.gif" />

## Mac note
Install [TunTap for Mac OS X](http://tuntaposx.sourceforge.net/) first.

## Server-side sudo note
If you do not have passwordless **sudo** on the side of SSH server, you will need to enter **sudo** password every time you connect to this server. You will be also unable to use `xaval` "background" connect option (see `xaval toggle`).

## Route discovery
Specifying routes by hand is not bad. But we could make it better by creating an executable `discover-routes` script in the project directory. If no routes are passed by hand, `xiringuito` will run `discover-routes`, pass SSH server hostname to it and use script output as a list of routes, so you may have per-host or per-domain route lists instead of boring manual typing. More information is available in [AWS example](https://github.com/ivanilves/xiringuito/blob/master/discover-routes.aws.example) which uses AWS CLI to discover VPC subnets and route traffic to them through our VPN tunnel.

## You can have many of them!
As long as your routes do not overlap, you can run as many `xiringuito` tunnels as you want. **Simultaneously!**

## xirin... WHAT?
"xiringuito" is a Catalan way of saying popular Spanish word "chiringuito", which usually means a beach bar in a more or less provisional building. As long as such places usually stand on a loose surface, operate without license and work only with cash, in urban dictionary "chiringuito" could mean any dodgy business, any activity of questionable legality and confidence. I've picked up this name because I've wrote this as a quick temporary hack, partially in a bus, partially in a train, while travelling back and forth between job and home. But ... nothing is more permanent than the temporary, right? :smile:

<img src="images/xiringuito.png" width="256px" />

## Future?
For now we can do bug fixes and minor UX improvements, however we see rewriting `xiringuito` in statically typed language as the major goal and a prerequirement before anything else.

## What's the difference between `xiringuito` and `sshuttle`?
[sshuttle](https://github.com/apenwarr/sshuttle) is a very popular SSH over VPN client. Though both projects look similar, there are at least three differences:

* `xiringuito` works well with RTP (Real-time Transport Protocol). This is a UDP-based protocol, the key difference between RTP and most of other UDP protocols - it used bi-directional media transport with random ports assigned on both ends. For me `sshuttle` was unable to correctly handle RTP traffic, while `xiringuito` due to utilization of tun/tap devices, does it transparently w/o issues.

* For the same reason `xiringuito` works with low-level (non-TCP & non-UDP) IP protocols like OSPF, L2TP, PPP, IGMP, IPSec, ARP, etc. While nobody should use SSH tun/tap to tunnel these protocols on production, `xiringuito` may serve you great to do some remote testing of these protocols with SSH-only connection to the infrastructure.

* No Python required! Well, this is not a solid reason to use `xiringuito`, but not everybody likes Python.

*`sshuttle` is a great piece of software. It suits web developers and DevOps/SysAdmins of typical web-centric projects very well. However, if you work with less typical services, or you hate Python (or love Bash), `xiringuito` may be a great choice :wink:*
