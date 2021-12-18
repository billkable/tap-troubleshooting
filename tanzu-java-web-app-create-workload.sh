#!/usr/bin/env bash

tanzu apps workload create tanzu-java-web-app \
  --label app.kubernetes.io/part-of=tanzu-java-web-app \
  --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
  --git-branch main \
  --type web \
  --label apps.tanzu.vmware.com/has-tests=true \
  --label tanzu.app.live.view.application.name=tanzu-java-web-app
