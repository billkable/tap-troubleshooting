# TAP Troubleshooting

## App Live View says `No live information for pod with id UUID`

Delete the live view connector (it'll get restarted automatically)
```
kubectl -n app-live-view delete pods -l=name=application-live-view-connector
```

## I edit `tap-values.yaml`, apply it, but the change doesn't take effect

If you installed the `tap` package, which transitively installs the package you are updating, then
instead of applying directly to the package you are updating, you should apply to the `tap` package.

For example:
```
tanzu package installed update tap --package-name tap.tanzu.vmware.com --version 0.5.0-build.1 -f tap-values.yml -n tap-install
```
