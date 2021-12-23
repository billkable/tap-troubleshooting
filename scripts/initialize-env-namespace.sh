#!/bin/env bash

# parameter descriptions
#
# - <target namespace> is the namespace in which to create the secret
#   you can omit it if your kubconfig context currently points to the
#   target namespace.
#

kubectl create namespace <target namespace>
kubectl config set-context --current --namespace <target namespace>
