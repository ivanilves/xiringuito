# xiringuito

*SSH-based VPN for poors*

VPN made easy! No configurations. No VPN servers. No hassle. **Just plug and use!**

This is the "VPN without VPN" software done using built-in capabilities of SSH.

## Install
```
git clone https://github.com/ivanilves/xiringuito.git
```

## Use
```
cd xiringuito
./xiringuito user@your.ssh.server 10.0.0.0/8 192.168.0.0/16
```
Yes! That easy - just pass an SSH server and the list of networks your want to access through this server.

You will need:
* Linux or Mac system.
* Local sudo privileges.
* Remote sudo privileges.

# Mac note
Install [TunTap for Mac OS X](http://tuntaposx.sourceforge.net/) first.
