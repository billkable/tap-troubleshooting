# Create image registry credentials

Your supply chain will need access to your image registry.

Configure a secret for it now:

```bash
tanzu secret registry add image-secret --server <registry server URL> --username <git username> --password <password or token> --namespace <namespace name>
```

An example using a github package registry:

```bash
tanzu secret registry add image-secret --server ghcr.io --username <github username> --password <github dev token> --namespace <namespace name> --export-to-all-namespaces
```
