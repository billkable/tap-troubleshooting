#!/bin/env bash

# parameter descriptions
#
# - $ACCELERATOR_ENDPOINT is the URL endpoint for the TAP accelerator
#
# - $COMPONENT_NAME is the name associated with your workload component
#   bootstrapped from the accelerator.
#   It will be set as the `part-of` annotation used by TAP GUI to select
#   it for runtime resource visualization.
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


tanzu accelerator generate tanzu-java-web-app \
    --server-url=$ACCELERATOR_ENDPOINT
    --options '{"projectName":"$COMPONENT_NAME", "repositoryPrefix":"$REGISTRY_SERVER/$REGISTRY_ACCOUNT/$COMPONENT_NAME"}'
