#!/usr/bin/env bash


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
#
# - <image repo name> is the name of the image repo,
#   ideally should be the `<component name>-src`
#

tanzu apps workload create <component name> \
  --local-path=.
  ----source-image=<registry server>/<registry account>/<image repo name>
  --type web \
  --label app.kubernetes.io/part-of=<component name> \
  --label apps.tanzu.vmware.com/has-tests=false \
  --label tanzu.app.live.view.application.name=<component name>
