# Cluster Setup

This section outlines a sample installation of
*Tanzu Application Platform* (TAP).

TAP is implemented to be "unopinionated" about how you set it up -
It can be installed on a raw Kubernetes (K8s) installation,
even on local developer-friendly environments like Kind and Minikube.
It can run production workloads on the main Cloud Provider flavors of
K8s like Amazon's *Elastic Kubernetes Service* (EKS),
*Google Kubernetes Engine* (GKE) or
Microsoft's *Azure Kubernetes Service* (AKS).
And of course,
TAP will run optimally on *Tanzu Kubernetes Grid* (TKG).

This workshop cluster installation lesson is on EKS given its simplicity
to get up-and-running.
The installation is not hardened for compliance and security,
although the workshop will touch on compliance and security issues,
and how TAP can help reduce Developer and Operator toil in the setup
and management.

This workshop also assumes use of Github as a source control repository,
as well as a Container registry, to minimize the number of 3rd party
dependencies and credentials.
You could, of course, use other git hosting providers such as Gitlab or
Bit Bucket.
You could also use other container registries such as DockerHub,
Google Container Registry (GCR),
or Amazon's Elastic Container Registry (ECR).

## EKS cluster setup

This lesson assumes the following Amazon requirements:

1.  You have an Amazon account with permissions to provision an EKS
    cluster.

1.  You will provision EKS with a minimum of 3 EC2 nodes
    (not on Fargate).

1.  You have an available Route 53 hosted zone where you will configure
    the required DNS host name "A" records for the various TAP public
    endpoints.

SSL certificates will not be configured,
and endpoints will be exposed via HTTP.

## TAP prereqs

### Accounts

You have the following accounts:

-   Github account where you will host:
    -   Your application source code repository
    -   Container image repositories for TAP installation packages as
        well as container images built for your application
    You will need to
    [set up a Personal Access Token (PAT)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
    with the following permissions:
    -   `repo`:
        all permissions
    -   `write:packages` (implicitly require `read:packages`)
    -   `delete:packages`
    You will provide the PAT as your password for https access and
    docker or container runtime access.

-   Tanzu Developer Network account -
    You will download workstation developer CLI and tooling,
    and configure your TAP installation to bootstrap the available
    packages for its PaaS installation.

### Developer Workstation

### TAP Package Bootstrap

###

## TAP full installation

## TAP OOB Basic Supply Chain installation
