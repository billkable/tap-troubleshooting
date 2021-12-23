# Using Tanzu Application Platform (TAP)

Product documentation link: <https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.4/tap/GUID-overview.html>

These exercises are meant to exercise various TAP features in the context of a [small Java Spring Boot
application](https://github.com/sample-accelerators/tanzu-java-web-app.git).

The examples are for a hypothetical setup with the following domains:

TAP GUI URL: <http://example.taproom.buzz:7000>
Knative base domain: <example-apps.taproom.buzz>
Learning Center domain: <example-learn.taproom.buzz>

## Setup command line completion

This is optional, but some folks will find it really handy for using the `tanzu` CLI.
If you use `bash`:

```
. <(tanzu completion bash)
```

## Create a Pipeline for the test phase

Our app uses Maven as its build and dependency management system, so we will create a Pipeline which
runs the `./mvnw test` command.

```
./mvn-pipeline-create.sh
```

## Create a Workload, using the `tanzu` CLI
THis is the _imperative_ way to create a Workload.

```
./tanzu-java-web-app-create-workload.sh
```
Notes on the file content:
- labels to get App Live View to work

Tail it to watch it build and start:

```
tanzu apps workload tail tanzu-java-webapp --since 10m --timestamp
```

To monitor the process of the test and/or scan phases, look for a pod with a meaningful name, and `kubectl logs` it.

## Get the workload info
```
tanzu apps workload get tanzu-java-webapp
```
The output should look like:
```
# tanzu-java-web-app: Ready
---
lastTransitionTime: "2021-12-10T21:29:42Z"
message: ""
reason: Ready
status: "True"
type: Ready

Workload pods
NAME                                                  STATE       AGE
tanzu-java-web-app-00002-deployment-996846c87-7k9cm   Running     19s
tanzu-java-web-app-b82kt-test-pod                     Succeeded   54m
tanzu-java-web-app-build-1-build-pod                  Succeeded   54m
tanzu-java-web-app-config-writer-wjm42-pod            Succeeded   53m

Workload Knative Services
NAME                 READY   URL
tanzu-java-web-app   Ready   http://tanzu-java-web-app.default.example-apps.taproom.buzz
```
The output includes the URL,

## Verify the app is accessible on the Internet

Point your browser at the running app:
<http://tanzu-java-web-app.default.example-apps.taproom.buzz/>

## Setup application to be visible in Application Live View in TAP GUI

Refer to the documentation in Getting Started (register component).
Note that the GitHub URL points at a catalog-info.yaml file that contains your application's metadata.
In this example: <https://github.com/sample-accelerators/tanzu-java-web-app/blob/main/catalog/catalog-info.yaml>

## Explore the TAP GUI
Go to the TAP GUI URL: <http://example.taproom.buzz:7000>

- Click on the "home" icon in the left column
- Click on `All` under `your organization`
- Click on the `tanzu-java-webapp` link
- Click on the `runtime resources` tab
- Expand the tree starting with `tanzu-java-webapp` until you arrive at the leaf node, with is of type Kubernetes Pod.
  For the resource of type `Knative Revision`, choose the latest one - since that's the only one that is currently serving requests!

_READER NOTE: Understanding the `Type` column requires knowledge of Kubernetes_

Click on the link to the Pod, which looks something like
`tanzu-java-web-app-00001-deployment-5bf487ff64-swqgv`.

Explore the `Live View` tile, which is somewhere in the middle of the screen.
_A known bug may require troubleshooting here - see Troubleshooting section/document._

## Update the Workload, using a YAML file
This is the _declarative_ way to create or update a Workload.

Export the Workload YAML:
```
tanzu apps workload get tanzu-java-web-app --export > tanzu-java-web-app.yaml
```
We'll add an environment variable.
Edit the above-created file with your favorite editor, adding the env key to the `spec:` field:

```
spec:
  env:
  - name: MY_ENV_VAR
    value: my env var value
```
Apply the change:
```
tanzu apps workload apply -f tanzu-java-web-app.yaml
```

Again, use the `tail` command (above) to watch the Supply Chain execute. When it has finished successfully,
go to the App Live View, find the newly-deployed Pod, and observe that under Environment / systemProperties
that the new env var is there.

Also note tha the env vars are visible in the Containers pane (under the Live View pane)

## Deploy Workload to another environment
_TODO_.
e.g., dev, staging.
This might require us to define a new Supply Chain? Not sure what the TAP story is here.
This is probably in the "App Ops" category in TAP's worldview.

## Add another pipeline
_TODO_.
Maybe use a Gradle pipeline instead of Maven.

## Configure scaling
_TODO_.
- Configure min and max replicas for Workload
- Configure auto-scaling rules (does it make sense to put this in Workload? There's a Slack conversation about this:
  <https://vmware.slack.com/archives/C02D60T1ZDJ/p1639732098105700>)

## Configure TLS/HTTPS
_TODO_.

## Securing SpringBoot actuators
_TODO_.
Looks like ALV cannot do this yet:
<https://vmware.slack.com/archives/C02D60T1ZDJ/p1639497937444600>

## Make a GIT repo private:
<https://vmware.slack.com/archives/C02D60T1ZDJ/p1639754807110500?thread_ts=1639754477.109600&cid=C02D60T1ZDJ>

## Creating SSH secrets for Github repos

### Generate the key

1.  `ssh-keygen -t <algorithm>`

    Where the `<algorithm>` is either `rsa` or `ed25519`.

    Name the private key file some known name,
    i.e. `github-ssh-key`.

1.  Set a deploy key in the target github repo for the public key
    generated, i.e. `github-ssh-key.pub`.

### Generate known hosts for Github

`ssh-keyscan github.com > ./known_hosts`

### Create the K8s secret

```bash
kubectl create secret generic git-ssh \
  --from-file=./github-ssh-key \
  --from-file=./github-ssh-key.pub \
  --from-file=./known_hosts -n <namespace>
```
