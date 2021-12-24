#!/usr/bin/env bash


# parameter descriptions
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
#
# - <image repo name> is the name of the image repo,
#   ideally should be the `$COMPONENT_NAME-src`
#

tanzu apps workload create $COMPONENT_NAME \
  --local-path=.
  ----source-image=$REGISTRY_SERVER/$REGISTRY_ACCOUNT/<image repo name>
  --type web \
  --label app.kubernetes.io/part-of=$COMPONENT_NAME \
  --label apps.tanzu.vmware.com/has-tests=false \
  --label tanzu.app.live.view.application.name=$COMPONENT_NAME
