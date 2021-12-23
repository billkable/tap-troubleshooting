#!/bin/env bash

# parameter descriptions
#
# - <registry server> is the root URL endpoint for the chosen image
#   registy provider.
#   Some examples:
#
#   - Docker: docker.io
#   - Google: gcr.io
#   - Github: ghcr.io
#
# - <registry account> is the registry provider account
#
# - <registry account password> is the password associated with the
#   registry
#
# - <target namespace> is the namespace in which to create the secret
#   you can omit it if your kubconfig context currently points to the
#   target namespace.
#

tanzu secret registry add registry-credentials \
    --server <registry server>
    --username <registry account>
    --password <registry account password>
    --namespace <target namespace>
    --export-to-all-namespaces