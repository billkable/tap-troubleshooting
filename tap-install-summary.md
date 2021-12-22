# TAP Installation Summary

## Prereqs

1.  K8s Cluster

1.  Cluster Essentials (Carvel cli and server installations)

1.  Tanzu cli & plugins

## Tanzu Package Installation

1.  Create TAP package installation namespace

1.  Create TAP package registry secret (for registry access)

1.  Add TAP package repository to cluster.

1.  Configure TAP resources.

1.  Install TAP package (and component packages).

# Post TAP install tasks

## Configure DNS

1.  Configure web workload ingress wildcard host name
    (for Cloud Native Runtime and associated Knative) to point to
    the contour envoy service load balancer address.

1.  Configure accelerator host name by pointing to the accelerator
    system server load balancer.

1.  Configure the TAP GUI hostname by point to the TAP GUI Server
    load balancer.

1.  Metadata store?

1.  Learning center?

## Create one or more developer namespaces

1.  Create developer namespace.

1.  Create image secret.

1.  Configure SA for image secret.

1.  Configure Roles for TAP resources.

1.  Bind roles to SA.