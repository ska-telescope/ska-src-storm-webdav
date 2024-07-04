# ska-src-storm-webdav

Deploy a containerised instance of StoRM-webdav on either a standalone machine or Kubernetes cluster (via Helm).

## Settings

Fill out the following sections of the helm template at `etc/helm/values.template.yml`:

- `extraEnv.STORM_WEBDAV_HOSTNAME_0`: the hostname serving this StoRM instance,
- `extraEnv.STORM_WEBDAV_REQUIRE_CLIENT_CERT`: "true" if serving over HTTPS, otherwise "false" if e.g. serving HTTP 
   sitting behind a TLS termination proxy,
- `config.certificates.host.crt`: the ssl host certificate,
- `config.certificates.host.key`: the ssl host certificate private key,
- `config.sa.sa.properties`: the storage area properties file, specifically `rootPath` and `accessPoints`,
- `ingress.host`: the hostname for ingress via the ingress-nginx controller,
- `persistence`: attributes to enable persistence of the storage area.

Persistence should nearly always be enabled to ensure storage element data is not lost.

## Deploy

Deployment is via Helm:

```bash
$ helm upgrade --install --create-namespace -n storm-webdav --values values.yaml ska-src-storm-webdav /path/to/ska-src-storm-webdav/etc/helm/
```

### Persistence

Persistence via dynamic volume provisioning is supported using a preconfigured storage class. This can be overriden 
by populating the `persistence.existingClaim` with the persistent volume claim for the (data) volume to be mounted.  

### Ingress

Ingress manifests for the `nginx-ingress` controller are provided.