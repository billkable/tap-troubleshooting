# TAP Developers Workload Overview

## Overview

In this workshop we will run you through a basic workload creation,
update, and monitoring:

1.  Generate a new application codebase and the source and delivery
    repos from an accelerator.

1.  Register the new application with TAP GUI.

1.  Generate a new workload configuration for the codebase.

1.  Create the workload configuration, monitor the supply chain from
    source to deployment.

1.  Manage the workload during "Day 2".
    -   Observe it through TAP GUI.
    -   Make an environment change, watch the reconfiguration and
        Blue/Green deployment.
    -   Make a code change, integrate to mainline and watch the supply
        chain test, build and deploy it.

## Monitoring

-   Monitor state of first class tanzu k8s derived objects:

    `watch kubectl get workload,gitrepository,pipelinerun,images.kpack,podintent,app,services.serving`
