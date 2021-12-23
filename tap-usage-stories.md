# TAP Usage Stories

## Overview

Developers using TAP may want to:

1.  Bootstrap a product codebase from TAP accelerator
1.  Setup or more TAP environments
1.  Deploy a workload in dev environments for inner loop activities
1.  Integrate with in CI/CD pipeline, resulting in a workload running in
    a target environment (review, testing, staging, production)
1.  Monitor or debug a workload running in an environment
1.  Tune the workloads in the target environment (configuration change)
1.  Fix bugs, add new features
    -   using inner loop activities prior to integrating work in dev
        environments
    -   integrating work to mainline,
        propagate through pipeline for target environment
    -   Documenting changes, features, etc

Note that items 5, 6 and 7 are considered "Day 2" activities,
and that they must consider continuous availability of the workload in
the target environment (this may be review, staging, or production).

## Bootstrapping a product and codebase

- Get a TAP cluster with full profile
- Generate a new component and its codebase from an accelerator
- Configure a remote source repository and its credentials
- Configure/acquire image registry and its credentials
- Register backstage component with TAP GUI
- Identify CI pipeline testing dependencies (maven vs gradle?)

## Setup Environments

### Developer

-   local provided (optional for inner loop development)

-   remote TAP provided

-   configure workload resource descriptor (or script)
    -   Configure local path and image source registry,
        or, configure repo and PR branch trigger
    -   Configure labels for basic or testing supply chain
    -   Configure label for backstage component

-   create k8s namespace

-   create environment credentials

### Review environment

-   remote TAP provided

-   configure workload resource descriptor (or script)
    - configure source repo and main branch trigger
    - configure labels for supply chain
    - configure label for backstage component



## Deploy Inner loop workloads

-   Developer can deploy workloads for development purposes before
    integrating to the mainline:
    -   private build from local workstation source code
    -   build from PR branch commits (similar to outer loop flow,
        but without compliance scans)
    -   Optional app live updates
        (probably limited use given the long build/deliver cycle)
    -   Remote debugging for TAP deployment dependent bug triage and
        fixes

## Outer loop integration and deployment

-   Developer integrates to mainline source control
-   "Outer Loop" activities:
    - Continuous integration pipeline (testing)
    - Source code vulnerability scans
    - Build image
    - Image signing and scans
    - Apply configuration (including conventions)
    - Deliver the deployment

## Monitor and Debug Workload

- Observe the workload runtime
- Diagnose workload runtime

## Tune Workload

-   Make environment config change and propagate through the config
    writer and delivery phases in supply chain.

## Add New Features, Fix Bugs

These activities likely include codebase changes that require container
image rebuilds.

All phases in the pipelines will be invoked,
including CI testing, container build, configuration, scanning and
delivery.

Documentation updates may be integrated also as part of the pipeline.

## Zero Downtime

Following the initial deployment of target environment workload,
the workload should experience zero downtime during the subsequent
"Day 2" activities, with minimal errors or disruptions.
