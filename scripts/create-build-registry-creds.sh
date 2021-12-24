#!/bin/env bash

# parameter descriptions
#
# - $REGISTRY_SERVER is the root URL endpoint for the chosen image
#   registy provider.
#   Some examples:
#
#   - Docker: docker.io
#   - Google: gcr.io
#   - Github: ghcr.io
#
# - $REGISTRY_ACCOUNT is the registry provider account
#
# - $REGISTRY_ACCOUNT_PASSWORD is the password associated with the
#   registry
#
# - $TARGET_NAMESPACE is the namespace in which to create the secret
#   you can omit it if your kubconfig context currently points to the
#   target namespace.
#

tanzu secret registry add registry-credentials \
    --server $REGISTRY_SERVER
    --username $REGISTRY_ACCOUNT
    --password $REGISTRY_ACCOUNT_PASSWORD
    --namespace $TARGET_NAMESPACE
    --export-to-all-namespaces