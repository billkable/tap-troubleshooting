# TAP Developers Workload Overview

TODO consider putting developer inner loop with Kind cluster
and locally triggered workloads.

## Overview

In this workshop we will run you through a basic workload creation,
update, and monitoring:

1.  Generate a new application codebase and the source and delivery
    repos from an accelerator.

1.  Register the new application with TAP GUI.

1.  Create and configure a TAP development namespace for CI and CD to
    a review environment.

1.  Generate a new workload configuration for the codebase.

1.  Create the workload configuration, monitor the supply chain from
    source to deployment.

1.  Simulate managing a workload during "Day 2".
    -   Observe it through TAP GUI.
    -   Make an environment change, watch the reconfiguration and
        Blue/Green deployment.
    -   Make a code change, integrate to mainline and watch the supply
        chain test, build and deploy it.

## Prepare a workload for GitOps

You need to prepare for a workload:

1.  Include a codebase for an app -
    ideally it comes from an accelerator,
    but maybe it does not.

1.  (Optionally) generate bakestage catalog information and/
    or linked tech documentation and backstage dependencies
    for the associated backstage service.

1.  Generate a source repository for the workload
    application.

1.  Generate a delivery repository for the workload runtime.

1.  Generate github secrets for GitRepository and (GitOps)
    TaskRun (if applicable).

1.  Development namespace created with the following:
    - build image registry credentials
    - service account with rbac and github secret reference
    - Tekton pipeline to test your application.

### Generate a codebase

In a terminal window,
navigate to a workspace directory,
such as `~/workspace`.

#### Generate from an accelerator

Generate a codebase using the `tanzu-java-web-app` accelerator:

```bash
tanzu accelerator generate tanzu-java-web-app --server-url=<accelerator endpoint> --options '{"projectName":"tal-tracker", "repositoryPrefix":"<registry server and account>/tal-tracker"}'
```

This will download a codebase in a zip file `tal-tracker.zip`.
It is a spring boot app skeleton with a web controller,
an associated API test,
and a maven build system.

Extract it in the workspace directory,
switch to it,
and test it:

```bash
cd ./tal-tracker
./mvnw test
```

If all is well the project test should succeed.

### Update the Backstage Catalog metadata

Change the description of the component from the accelerator provided
`Tanzu Java Web App` to `TAL Tracker`.

On nix systems use `sed`:

MacOSX (replace and remove backup):

```bash
sed -i.bu 's/Tanzu Java Web App/TAL Tracker/g' catalog-info.yaml
rm catalog-info.yaml.bu
```

Linux:

```bash
sed -i 's/Tanzu Java Web App/TAL Tracker/g' catalog-info.yaml
```

This will provide placeholder data for your project in TAP GUI later.

### Generate Source Repository

You need a git repository for your source code.
This section will walk you through the process.

#### Generate a local git repo

```bash
git init
```

*Note that you might get a warning about preference for default branch*
*name.*
*Examples here use `main`*.

The project already has a suitable `.gitignore` file,
so you can stage all the files and commit locally:

```bash
git add .
git commit -m'initial commit'
```

#### Create a remote source git repository

Create a remote repo on your provider of choice.
(Github, Gitlab, Bitbucket are the most common).

*It is recommended not to initialize the remote,*
*given you have initialized the local repository.*

Consider whether or not the repository will be public or private.
Private repos will require pull credentials as will be discussed in
later session.

For this lesson,
the author uses Github,
and creates and names the remote as follows:

`https://github.com/billkable/tal-tracker`

Add the remote, and
push the local repo to the remote:

```bash
git remote add origin https://github.com:billkable/tal-tracker.git
git push origin main
```

Checkout the web interface for your remote to verify the push succeeded.

### Generate Delivery Repository

Create a remote repo on your provider of choice.
(Github, Gitlab, Bitbucket are the most common).
Consider intuitive naming to correlate to the source repository and the
environment it reflects.

When creating the repository,
initialize with a README skeleton.
You can optionally mark up the README as a Delivery repository for the
workload runtime configuration.

For this lesson,
the author uses Github,
and creates and names the remote as follows:

`https://github.com/billkable/tal-tracker-review-config`

### Generate SSH Keys (if applicable for private repo)

Follow this section if you are running private repositories,
otherwise it is not required.

#### Generate SSH keys for GitRepository

1.  `ssh-keygen -t <algorithm>`

    Where the `<algorithm>` is either `rsa` or `ed25519`.

    Name the private key file `identity`.

1.  Set a deploy key in the src github repo for the
    public key generated, i.e. `identity.pub`.

#### Generate known hosts for Github SSH

`ssh-keyscan github.com > ./known_hosts`

## Register the workload component into TAP GUI

Visit the TAP GUI and execute the following actions:

1.  Click the *Register Entity* button.

1.  Add the path to the `catalog-info.yaml` file in your remote
    repository:

    `https://github.com/billkable/tal-tracker/blob/main/catalog-info.yaml`

1.  Click the *Analyze* button.

1.  Review the entities to be imported, the `component:tal-tracker` as
    well as the location.

1.  Click the *Import* button.

1.  Navigate to TAP GUI Home.

1.  Click "All" at *YOUR ORGANIZATION*.
    You should see `tal-tracker` entry in the entity list.
    You can star it as a favorite if you like.

1.  Click on the `tal-tracker` entry.
    You will not see much information for this component,
    as there is minimal documentation and backstage dependencies
    configured for it.

1.  Click on the *VIEW SOURCE* option in the *About* section.
    You should see a posted link back to the source repository.

1.  From the TAP GUI `tal-tracker` page,
    click the *RUNTIME RESOURCES* option.
    You will see that no runtime resources are yet available,
    because you have not yet configured and deployed the associated
    workload yet.

## Create and configure a developer namespace (if not already created)

Before creating and configuring a workload,
you need a place to run the associated supply chain and its delivered
runtime.

TAP uses the K8s namespace to isolate where the workloads are configured
and run.

### Create namespace and set context

The development continuous integration and delivery pipelines will use
the TAP supply chain.
The resources will run in a dedicated namespace.

Create the namespace named `tal-review` and switch to it as the
current context:

```bash
kubectl create namespace tal-review
kubectl config set-context --current --namespace tal-review
```

### Create the K8s ssh secrets for private repos

Ignore this section if you are not running private repos.

TODO verify instructions vs #tap-assist

Create secrets for both your source code and config repos:

Source:

```bash
kubectl create secret ssh-auth src-git-ssh \
  --from-file=./identity \
  --from-file=./identity.pub \
  --from-file=./known_hosts -n <namespace>
```

Delivery (the `ssh-privatekey` is a copy of `identity`)

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: git-ssh
  annotations:
    tekton.dev/git-0: github.com  # git server host
type: kubernetes.io/ssh-auth
stringData:
  ssh-privatekey: string          # private key with push-permissions
  known_hosts: string             # git server public keys
  identity: string                # private key with pull permissions
  identity.pub: string            # public of the `identity` private key
EOF
```

### Github Basic Auth creds

While not running private repositories,
push access will be required for the Delivery repository.

It is recommended to use a basic auth strategy using the git provider's
preferred HTTP basic auth strategy
(Github uses the github user name and a developer token).

Create the secret as follows:

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: git-auth
  annotations:
    tekton.dev/git-0: https://github.com # set according to provider url
type: kubernetes.io/basic-auth
stringData:
  username: <github user name>
  password: <github dev token>
EOF
```

*This secret*
`git-auth`
*must be added to the service account in the developer namespace.*
*You will see in a later step*

### Create image registry credentials

Your supply chain will need access to your image registry.

In this lesson,
the author is using Github Container Registry and the associated
Github credentials.

Configure a secret for it now:

```bash
tanzu secret registry add registry-credentials --server ghcr.io --username billkable --password <github dev token> --namespace tal-review --export-to-all-namespaces
```

### Configure namespace with access control

Your namespace and associated service account will need access to the
supply chain resources,
as well as the repository and registry credentials:

```bash
cat <<EOF | kubectl -n tal-review apply -f -
---
apiVersion: v1
kind: Secret
metadata:
  name: tap-registry
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: e30K

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
secrets:
  - name: registry-credentials
  - name: git-auth
imagePullSecrets:
  - name: registry-credentials
  - name: tap-registry

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: default
rules:
- apiGroups: [source.toolkit.fluxcd.io]
  resources: [gitrepositories]
  verbs: ['*']
- apiGroups: [source.apps.tanzu.vmware.com]
  resources: [imagerepositories]
  verbs: ['*']
- apiGroups: [carto.run]
  resources: [deliverables, runnables]
  verbs: ['*']
- apiGroups: [kpack.io]
  resources: [images]
  verbs: ['*']
- apiGroups: [conventions.apps.tanzu.vmware.com]
  resources: [podintents]
  verbs: ['*']
- apiGroups: [""]
  resources: ['configmaps']
  verbs: ['*']
- apiGroups: [""]
  resources: ['pods']
  verbs: ['list']
- apiGroups: [tekton.dev]
  resources: [taskruns, pipelineruns]
  verbs: ['*']
- apiGroups: [tekton.dev]
  resources: [pipelines]
  verbs: ['list']
- apiGroups: [kappctrl.k14s.io]
  resources: [apps]
  verbs: ['*']
- apiGroups: [serving.knative.dev]
  resources: ['services']
  verbs: ['*']
- apiGroups: [servicebinding.io]
  resources: ['servicebindings']
  verbs: ['*']
- apiGroups: [services.apps.tanzu.vmware.com]
  resources: ['resourceclaims']
  verbs: ['*']
- apiGroups: [scst-scan.apps.tanzu.vmware.com]
  resources: ['imagescans', 'sourcescans']
  verbs: ['*']

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: default
subjects:
  - kind: ServiceAccount
    name: default

EOF
```

## Create a CI testing pipeline

Create a testing pipeline for your spring boot app using
maven testing:

```bash
kubectl apply -f - <<EOF
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: tekton-mvn-pipeline
  labels:
    apps.tanzu.vmware.com/pipeline: test     # (!) required
spec:
  params:
    - name: source-url                       # (!) required
    - name: source-revision                  # (!) required
  tasks:
    - name: test
      params:
        - name: source-url
          value: $(params.source-url)
        - name: source-revision
          value: $(params.source-revision)
      taskSpec:
        params:
          - name: source-url
          - name: source-revision
        steps:
          - name: test
            image: gradle
            script: |-
              cd `mktemp -d`

              wget -qO- $(params.source-url) | tar xvz
              ./mvnw test
EOF
```

## Create and configure a workload

The initial configuration and creation of the workload is
done through the `tanzu apps workload` cli command:

```bash
tanzu apps workload create tal-tracker \
  --git-repo https://github.com/billkable/tal-tracker.git \
  --git-branch main \
  --param "delivery_git_branch=main" \
  --param "delivery_git_commit_message=bump" \
  --param "delivery_git_repository=https://github.com/billkable/tal-tracker-review-config.git" \
  --param "delivery_git_user_email=bkable@gmail.com" \
  --param "delivery_git_user_name=billkable" \
  --param "delivery_git_ssh_secret=git-auth" \
  --label apps.tanzu.vmware.com/has-tests=true \
  --label app.kubernetes.io/part-of=tal-tracker \
  --type web
```

## Monitor it

Run the following commands in separate terminal windows:

```bash
watch kubectl get workload,gitrepository,pipelinerun,images.kpack,podintent,app,services.serving

watch kubectl get pods
```

Watch the test, build, configure and deploy steps complete,
then post the workload url in a browser to test it.

Hints:

1.  In the pod watch window,
    observe the pod creation.
    You will see similar pod names and run in the supply chain order:

    - `tal-tracker-xxxx-test-pod`
    - `tal-tracker-xxxx-build-1-build-pod`
    - `tal-tracker-xxxx-config-writer-xxxx-pod`
    - `tal-tracker-00001-deployment-xxxxxxxxx-xxx`

1.  In the resource watch window,
    watch the:

    -   workload supply chain run creation:
        `workload.carto.run/tal-tracker`

    -   Git repository triggers by flux cd for both the source and
        delivery registries:
        `gitrepository.source.toolkit.fluxcd.io/tal-tracker`
        `gitrepository.source.toolkit.fluxcd.io/tal-tracker-delivery`

    -   Testing (Tekton) pipeline run for CI testing:
        `pipelinerun.tekton.dev/tal-tracker-xxxxx`

    -   Tanzu Build Service image building:
        `image.kpack.io/tal-tracker`

    -   Configuration Writer convention application and push of runtime
        configuration to the delivery repository:
        `podintent.conventions.apps.tanzu.vmware.com/tal-tracker`

    -   The associated Carvel Application:
        `app.kappctrl.k14s.io/tal-tracker`

    -   The associated Cloud Native Runtime (CNR, Knative) service:
        `service.serving.knative.dev/tal-tracker`

        You can see the ingress URL here that you will use to acces in
        a browser,
        and configure in a subsequent load test.

Verify the delivery configuration the supply chain configuraton writer
pushes to your
[delivery repository](https://github.com/billkable/tal-tracker-review-config/blob/main/config/delivery.yml).

The supply chain Delivery will monitor this repository for desired state
changes,
and apply by deploying a new Cloud Native Runtime (Knative) Revision.

You will see this in action in upcoming steps.

## Run some load for awhile

Now that you have a workload deployed and running,
run some load against it with a load test tool.

In this lesson the author uses [k6s](https://k6s.io),
either from local command line,
or from the [k6s Cloud Runner](https://app.k6.io/account/login)

### Sample load test script

The load test scenario simulates ~10 requests/seconds for ~half hour
with 10 virtual users.

The idea is to run continuous load while completing the remaining
exercises to demonstrate the zero-downtime capabilities of Cloud Native
Runtime.

The k6s script is as follows - you can run it from the command line,
or import and run it on k6s cloud runner:

```json
import { sleep, check } from "k6";
import http from "k6/http";

export const options = {
  ext: {
    loadimpact: {
      distribution: {
        "amazon:us:ashburn": { loadZone: "amazon:us:ashburn", percent: 100 },
      },
    },
  },
  stages: [
    { target: 10, duration: "10s" },
    { target: 10, duration: "29m40s" },
    { target: 0, duration: "10s" },
  ],
  thresholds: {},
};

export default function main() {
  let response;

  // Greeting
  response = http.get("<TAL Tracker CNR Service ingress URL>");
  check(response, {
    "status equals 200": response => response.status.toString() === "200",
  });
  sleep(1);
}
```

### Running the load test

If you choose to run locally,
[install k6s cli](https://k6.io/docs/getting-started/installation/),
save the load test script locally as `tal-tracker-load-test.json` and
run as follows:

`k6 run ./tal-tracker-load-test.json`

Ideally you should not see errors during its execution,
although occasion transient failures may happen.

## TAP GUI Runtime diagnostics

Revisit the TAP GUI for TAP:

-   Expand the `Knative Service` hierarchy and review the component
    parts:
    - Knative Service
    - Knative Configuration
    - Knative Revision
    - K8s Deployment
    - K8s ReplicaSet
    - K8s Pod

You can also visualize from the command line with the `kubectl tree`
plugin:

`kubectl tree service.serving.knative.dev tal-tracker`

whose output should look like:

```no-highlight
NAMESPACE   NAME                                                                          READY  REASON  AGE
tal-review  Service/tal-tracker                                                           True           50m
tal-review  ├─Configuration/tal-tracker                                                   True           50m
tal-review  │ └─Revision/tal-tracker-00001                                                True           50m
tal-review  │   ├─Deployment/tal-tracker-00001-deployment                                 -              50m
tal-review  │   │ └─ReplicaSet/tal-tracker-00001-deployment-557768687                     -              50m
tal-review  │   │   └─Pod/tal-tracker-00001-deployment-557768687-6x2jb                    True           9m2s
tal-review  │   ├─Image/tal-tracker-00001-cache-workload                                  -              50m
tal-review  │   └─PodAutoscaler/tal-tracker-00001                                         True           50m
tal-review  │     ├─Metric/tal-tracker-00001                                              True           50m
tal-review  │     └─ServerlessService/tal-tracker-00001                                   True           50m
tal-review  │       ├─Endpoints/tal-tracker-00001                                         -              50m
tal-review  │       │ └─EndpointSlice/tal-tracker-00001-wgd5t                             -              50m
tal-review  │       ├─Service/tal-tracker-00001                                           -              50m
tal-review  │       └─Service/tal-tracker-00001-private                                   -              50m
tal-review  │         └─EndpointSlice/tal-tracker-00001-private-s5zbw                     -              50m
tal-review  └─Route/tal-tracker                                                           True           50m
tal-review    ├─Endpoints/tal-tracker                                                     -              50m
tal-review    │ └─EndpointSlice/tal-tracker-ghtl6                                         -              50m
tal-review    ├─Ingress/tal-tracker                                                       True           50m
tal-review    │ ├─HTTPProxy/tal-tracker-contour-tal-tracker.tal-review                    -              50m
tal-review    │ ├─HTTPProxy/tal-tracker-contour-tal-tracker.tal-review.apps.taproom.buzz  -              50m
tal-review    │ ├─HTTPProxy/tal-tracker-contour-tal-tracker.tal-review.svc                -              50m
tal-review    │ └─HTTPProxy/tal-tracker-contour-tal-tracker.tal-review.svc.cluster.local  -              50m
tal-review    └─Service/tal-tracker                                                       -              50m
```

## Update the codebase with a configurable welcome message

### Code change

Add feature to make the greeting message configurable in the
`HelloController`:

```diff
 package com.example.springboot;

+import org.springframework.beans.factory.annotation.Value;
 import org.springframework.web.bind.annotation.RestController;
 import org.springframework.web.bind.annotation.RequestMapping;

 @RestController
 public class HelloController {
+       private final String message;
+
+       public HelloController(@Value("${welcome.message:Default message}")String message) {
+               this.message = message;
+       }

        @RequestMapping("/")
        public String index() {
-               return "Greetings from Spring Boot + Tanzu!";
+               return message;
        }

 }
```

Remember to change your test to capture the default message:

```diff
class HelloControllerTest {

     @Test
     void index() throws Exception {
-        assertEquals("Greetings from Spring Boot + Tanzu!", controller.index());
+        assertEquals("Default message", controller.index());

         mockMvc
             .perform(get("/"))
             .andExpect(status().isOk())
-            .andExpect(content().string("Greetings from Spring Boot + Tanzu!"));
+            .andExpect(content().string("Default message"));
     }
 }
```

After making the changes make sure to test it locally:

```bash
./mvnw test
```

### Commmit and push the change

```bash
git add src -p # verify changes
git commit -m'add configurable welcome message'
git push origin main
```

### Observe test, build, configure and run

Observe the code change propagate through the pipeline,
similar to the initial workload creation.

Once the deployment is complete,
verify:

-   Deployment 00002 is running
-   The new default message from the Cloud Native Runtime endpoint
-   No (or minimal errors) from the load test output
-   Deployment 00001 will terminate after a couple of minutes following
    deployment 00002 running

You just completed a zero downtime CI and CD cycle!

## Update the runtime environment through the workload

Now update the message through the new WELCOME_MESSAGE environment
variable.

You will first do that imperatively through the `tanzu app workload` cli.

```bash
tanzu apps workload update tal-tracker \
  --env "WELCOME_MESSAGE=Welcome from the TAP Room"
```

Watch for the config writer to update the runtime configuration,
as well as generation of CNR revision 00003.

revision 00002 should terminate after a minute or two,
and there should be no (or minimal) errors during the load test.

Also review the latest push to the
[delivery configuration](https://github.com/billkable/tal-tracker-review-config/blob/main/config/delivery.yml).

You should see the environment variable update in the
`spec.container.env` entry for the `WELCOME_MESSAGE`.

## Update the runtime environment through the Delivery

You will update the
[delivery configuration](https://github.com/billkable/tal-tracker-review-config/blob/main/config/delivery.yml)
in the repository.

You can clone the repo and make changes to the `WELCOME_MESSAGE`
environment variable value, then commit and push the changes,
or,
you can make the changes and commit directly through the Github UI
(assuming you are using Github).

Make the environment specification look like the following:

```yaml
    spec:
      containers:
      - env:
        - name: WELCOME_MESSAGE
          value: Welcome from the TAP Room, part 2
```

and commit/push your changes.

You will notice there is no activity in the supply chain -
but you will see Cloud Native Runtime deploys the next revision 0004.

You made a desired state change directly in the Delivery state in the
associated repository,
and the ClusterDelivery reconciliation will make the active state
equal to the new desired state via the new deployment.

## Wrapping up

Hopefully you completed all the steps before the load test runs out.

If you did,
grab a coffee and let it finish.

If not,
no worries.

Ideally your load test output should look similar to below,
with 100% checks complete, and 0% http requests failed.

A small amount of transient failures is OK.


```no-highlight
          /\      |‾‾| /‾‾/   /‾‾/
     /\  /  \     |  |/  /   /  /
    /  \/    \    |     (   /   ‾‾\
   /          \   |  |\  \ |  (‾)  |
  / __________ \  |__| \__\ \_____/ .io

  execution: local
     script: ./tal-tracker-load-test.json
     output: -

  scenarios: (100.00%) 1 scenario, 10 max VUs, 30m30s max duration (incl. graceful stop):
           * default: Up to 10 looping VUs for 30m0s over 3 stages (gracefulRampDown: 30s, gracefulStop: 30s)


running (30m00.4s), 00/10 VUs, 17603 complete and 0 interrupted iterations
default ✓ [======================================] 00/10 VUs  30m0s

     ✓ status equals 200

     checks.........................: 100.00% ✓ 17603    ✗ 0
     data_received..................: 3.7 MB  2.1 kB/s
     data_sent......................: 1.9 MB  1.0 kB/s
     http_req_blocked...............: avg=14.44µs min=1µs     med=4µs     max=88.41ms p(90)=5µs     p(95)=6µs
     http_req_connecting............: avg=5.95µs  min=0s      med=0s      max=11.74ms p(90)=0s      p(95)=0s
     http_req_duration..............: avg=15.99ms min=10.42ms med=14.38ms max=6.57s   p(90)=16.37ms p(95)=17.7ms
       { expected_response:true }...: avg=15.99ms min=10.42ms med=14.38ms max=6.57s   p(90)=16.37ms p(95)=17.7ms
     http_req_failed................: 0.00%   ✓ 0        ✗ 17603
     http_req_receiving.............: avg=45.71µs min=11µs    med=42µs    max=1.58ms  p(90)=65µs    p(95)=78µs
     http_req_sending...............: avg=16.5µs  min=4µs     med=15µs    max=112µs   p(90)=24µs    p(95)=29µs
     http_req_tls_handshaking.......: avg=0s      min=0s      med=0s      max=0s      p(90)=0s      p(95)=0s
     http_req_waiting...............: avg=15.93ms min=10.37ms med=14.32ms max=6.57s   p(90)=16.31ms p(95)=17.63ms
     http_reqs......................: 17603   9.777064/s
     iteration_duration.............: avg=1.01s   min=1.01s   med=1.01s   max=7.66s   p(90)=1.01s   p(95)=1.01s
     iterations.....................: 17603   9.777064/s
     vus............................: 1       min=1      max=10
     vus_max........................: 10      min=10     max=10
```