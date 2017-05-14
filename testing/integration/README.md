#### Integration testing in Xiringuito

We do integration testing with Docker against two platforms:
* Ubuntu 16.04
* CentOS 7

Next cases (and even more) are covered:
* Running with SSH agent
* Running with SSH private key loaded directly from FS
* With invalid SSH keys or w/o ones (predictable failure)
* With and without route discovery
* With and without reconnection
* With and without propagation of server DNS configuration
* Tearing down both client and server with no garbage left
