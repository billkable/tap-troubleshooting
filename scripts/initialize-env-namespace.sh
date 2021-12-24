#!/bin/env bash

# parameter descriptions
#
# - $TARGET_NAMESPACE is the namespace in which to create the secret
#   you can omit it if your kubconfig context currently points to the
#   target namespace.
#

kubectl create namespace $TARGET_NAMESPACE
kubectl config set-context --current --namespace $TARGET_NAMESPACE
