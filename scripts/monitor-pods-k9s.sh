#!/bin/env bash

# parameter descriptions
#
# - $TARGET_NAMESPACE is the namespace to set k9s context for pod
#   monitoring
#

k9s --namespace $TARGET_NAMESPACE
