#!/bin/env bash

# parameter descriptions
#
# - <component name> is the workload name and the same as the
#   component name associated with generated accelerator project,
#   and registered with TAP GUI.
#
# - <env var> is the environment variable key
#
# - <env var value> is the environment variable value

tanzu apps workload update <component name> \
    --env "<env var>=<env var value>"
