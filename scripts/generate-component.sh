#!/bin/env bash

# parameter descriptions
#
# - <component name> is the name associated with your workload component
#   bootstrapped from the accelerator.
#   It will be set as the `part-of` annotation used by TAP GUI to select
#   it for runtime resource visualization.
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


tanzu accelerator generate tanzu-java-web-app \
    --server-url=<accelerator endpoint>
    --options '{"projectName":"<component-name>", "repositoryPrefix":"<registry server>/<registry account>/<component-name>"}'
