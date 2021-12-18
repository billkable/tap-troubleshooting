#!/usr/bin/env bash

set -e

cat <<'EOF' > gradle-test-pipeline.yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: gradle-test-pipeline
  labels:
    apps.tanzu.vmware.com/pipeline: test
spec:
  params:
    - name: source-url
    - name: source-revision
  tasks:
    - name: test
      params:
        - name: source-url
          value: $(params.source-url)
        - name: source-revision
          value: $(params.source-revision)
      taskSpec:
        params:
          - name: source-url
          - name: source-revision
        steps:
          - name: test
            image: bitnami/java:11
            script: |-
              cd `mktemp -d`

              wget -qO- $(params.source-url) | tar xvzf -
              ./gradlew test
EOF

kubectl apply -f gradle-test-pipeline.yaml
