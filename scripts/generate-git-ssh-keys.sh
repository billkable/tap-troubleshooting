#!/bin/env bash

# parameter descriptions
#
# - <algorithm> key generation algorithm,
#   pick either `rsa` or `ed25519`
#
# - <output key file> is the file name of the private key that will be
#   generated, as well as the public key with the name
#   `<output key file>.pub`
#
# - <git provider> is the hostname of the provider,
#   For github: `github.com`
#

ssh-keygen -t <algorithm> -f <output key file> -q -N ""
ssh-keyscan <git provider> > known_hosts