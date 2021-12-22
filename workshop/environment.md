
# Prepare a TAP provided environment

## Environment prerequisites

You will need the following before setting up an environment:

-   TAP/K8s cluster provisioned per [Prerequisites](./tap-dev-lessons.md#prerequisites)
    section.

-   Git repositories must be provisioned:

    -   *Source code repository* where the source code lives.
        This is required for Outer loop development when the supply
        chain sources changes and propagates through Continuous
        Integration and Delivery to an environment.
        It may also be used as part of inner loop development if using
        PR branches as a source.

    -   *Delivery repository* is required for GitOps style tracking of
        workload runtime configuration changes.
        Credentials must be available at a minimum for pushing during
        the configuration stage of the supply chain.

    -   Git SSH keys and known hosts,
        or git basic authentication credentials,
        must be available if using private
        repositories.

-   Image registry must be available where to store and retrieve
    source (for inner loop development),
    bundles, or delivery images necessary to run Cloud Native
    Runtime (CNR) workloads on the TAP K8s cluster.
    Credentials will be required.

Note that the environment credentials will be configured as K8s
secrets in a dedicated environment namespace,
and assigned to the namespace default service account.

## Create environment namespace

Create the k8s namespace for the target environment.

For example a dedicated developer namespace may be `developer-billkable`,
and a dedicated review environment namespace may be `tal-review`.

Create the namespace:

`kubectl create namespace <namespace name>`

## Set up environment resource access

- [Setup Git credentials](./git-secrets)
- [Setup image registry access](./registry-creds)
- [Setup namespace service account access](./setup-environment-access)
