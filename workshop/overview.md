# TAP Usage Overview

This workshop has a series of lessons that will demonstrate the
common developer uses of *Tanzu Application Platform* (TAP).

It is designed as a 200-level path that takes you from initial project
setup to deployment and management of an application running on TAP with
zero downtime.
What distinguishes this series from the other "Getting Started"
documentation and workshops is that the you will get a guided tour of
what happens under the hood with TAP,
with the outcome of giving a better mental model of how TAP leverages
Kubernetes (K8s) and prominent components in the K8s ecosystem to build
a compelling PaaS.

## Lessons

The following lessons are broken out in sequence:

-   [Bootstrap of a new project and component](bootstrap.md)

-   [An example cluster setup on Amazon Elastic Kubernetes Service (EKS)](cluster-setup.md)

-   [Setup of environments in a potentially multi-tenant TAP cluster](env-setup.md):
    - Development
    - Review

-   [Inner loop development activities](inner-loop-dev.md)

-   [Continuous Integration and Delivery](ci-cd-outer-loop.md)

-   [Day 2 concerns](day-2.md)
    - Feature updates
    - Configuration updates
    - Zero downtime upgrades
    - Monitoring
