#!/bin/env bash

# parameter descriptions
#
# - $COMPONENT_NAME is the workload name and the same as the
#   component name associated with generated accelerator project,
#   and registered with TAP GUI.
#
# - <env var> is the environment variable key
#
# - <env var value> is the environment variable value

tanzu apps workload update $COMPONENT_NAME \
    --env "<env var>=<env var value>"
