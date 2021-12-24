#!/usr/bin/env bash

# parameter descriptions
#
# - $COMPONENT_NAME is the name associated with your workload component
#   bootstrapped from the accelerator.
#   It will be set as the `part-of` annotation used by TAP GUI to select
#   it for runtime resource visualization.
#
# - <source code git repository> is the git repository URL associated
#   with the source code repository.

tanzu apps workload create $COMPONENT_NAME \
  --git-repo <source code git repository> \
  --git-branch main \
  --type web \
  --label app.kubernetes.io/part-of=$COMPONENT_NAME \
  --label apps.tanzu.vmware.com/has-tests=true \
  --label tanzu.app.live.view.application.name=$COMPONENT_NAME