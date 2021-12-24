#!/bin/env bash

# parameter descriptions
#
# - $ALGORITHM key generation algorithm,
#   pick either `rsa` or `ed25519`
#
# - $OUTPUT_KEY_FILE is the file name of the private key that will be
#   generated, as well as the public key with the name
#   `$OUTPUT_KEY_FILE.pub`
#
# - $GIT_PROVIDER is the hostname of the provider,
#   For github: `github.com`
#

ssh-keygen -t $ALGORITHM -f $OUTPUT_KEY_FILE -q -N ""
ssh-keyscan $GIT_PROVIDER > known_hosts