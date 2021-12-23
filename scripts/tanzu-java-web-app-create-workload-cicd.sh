#!/usr/bin/env bash

# parameter descriptions
#
# - <component name> is the name associated with your workload component
#   bootstrapped from the accelerator.
#   It will be set as the `part-of` annotation used by TAP GUI to select
#   it for runtime resource visualization.
#
# - <source code git repository> is the git repository URL associated
#   with the source code repository.

tanzu apps workload create <component name> \
  --git-repo <source code git repository> \
  --git-branch main \
  --type web \
  --label app.kubernetes.io/part-of=<component name> \
  --label apps.tanzu.vmware.com/has-tests=true \
  --label tanzu.app.live.view.application.name=<component name>