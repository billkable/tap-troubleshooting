## Create environment repository secrets

### Git SSH secrets for private environments

#### Generate SSH keys

1.  `ssh-keygen -t <algorithm>`

    Where the `<algorithm>` is either `rsa` or `ed25519`.

    Name the private key file `identity`.

1.  Set a deploy key in the src github repo for the
    public key generated, i.e. `identity.pub`.

#### Generate known hosts for Github SSH

`ssh-keyscan github.com > ./known_hosts`

#### Create K8s Git SSH secret

TODO:  Does not appear to work in Beta 4 (0.4.0) per instructions.

Create secret for GitRepository pull access for source and delivery
(if using GitOps) pipelines:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: git-ssh
  annotations:
    tekton.dev/git-0: github.com  # git server host
type: kubernetes.io/ssh-auth
stringData:
  ssh-privatekey: string          # private key with push-permissions for delivery pipeline
  known_hosts: string             # git server public keys
  identity: string                # private key with pull permissions
  identity.pub: string            # public of the `identity` private key
```

### Git Basic Auth creds

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
  username: <git user name>
  password: <git password or token>
EOF
```

*This secret*
`git-auth`
*must be added to the service account in the developer namespace.*
*You will see in a later step*
