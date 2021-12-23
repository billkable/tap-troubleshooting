#!/usr/bin/env bash

# From Slack thread https://vmware.slack.com/archives/C02D60T1ZDJ/p1637271390100200

set -e

kubectl patch -n knative-serving configmap config-autoscaler --patch '{"data": {"enable-scale-to-zero": "false"}}' --type=merge
