# ska-src-storm-webdav

Deploy a containerised instance of StoRM-webdav on either a standalone machine (via Docker) or Kubernetes cluster 
(via Helm).

[[_TOC_]]

## Configuration

### Docker

For deployment using Docker, you will need to create (new) TLS keys in `etc/host-certificate` and configure the 
application/storage areas under `etc/storm-webdav/config/application.yml` and `etc/storm-webdav/sa.d/*` respectively.

Be sure to remove the `.template` suffix from any storage areas that you want to include.

### Helm

For deployment using Helm, you will need to define the TLS keys and application/storage area configuration in 
the chart's `values.yml`.

For deployment using Helm, fill out the following sections of the helm template at `etc/helm/values.template.yml`:

- `extraEnv.STORM_WEBDAV_HOSTNAME_0`: the hostname serving this StoRM instance,
- `extraEnv.STORM_WEBDAV_REQUIRE_CLIENT_CERT`: "true" if serving over HTTPS, otherwise "false" if e.g. serving HTTP 
   sitting behind a TLS termination proxy,
- `config.certificates.host.crt`: the ssl host certificate,
- `config.certificates.host.key`: the ssl host certificate private key,
- `config.sa.sa.properties`: the storage area properties file, specifically `rootPath` and `accessPoints`,
- `ingress.host`: the hostname for ingress via the ingress-nginx controller,
- `persistence`: attributes to enable persistence of the storage area.

#### Persistence

Persistence should nearly always be enabled to ensure storage element data is not lost.

Persistence via dynamic volume provisioning is supported using a preconfigured storage class. This can be overriden 
by populating the `persistence.existingClaim` with the persistent volume claim for the (data) volume to be mounted.  

#### Ingress

Ingress manifests for the `nginx-ingress` controller are provided.

## Deployment

### Docker

The TLS keys and application/storage areas must be mounted in the expected locations. The example `docker-compose` file 
illustrates the necessary volume mounts.

#### Example (docker-compose)

```bash
ska-src-storm-webdav$ docker-compose up
```

### Helm

Helm charts exist for deployment on to kubernetes clusters. 

#### Example

```bash
ska-src-storm-webdav$ helm upgrade --install --create-namespace -n storm-webdav --values values.yml ska-src-storm-webdav etc/helm/
```

