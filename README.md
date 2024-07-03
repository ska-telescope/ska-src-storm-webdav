# ska-src-storm-webdav

Deploy a containerised instance of StoRM-webdav on either a standalone machine or Kubernetes cluster (via Helm).

## Usage

First, fill out the following sections of the helm template at `etc/helm/values.template.yml`:

- extraEnv.STORM_WEBDAV_HOSTNAME_0: the hostname serving this StoRM instance,
- extraEnv.STORM_WEBDAV_REQUIRE_CLIENT_CERT: "true" if serving over HTTPS, otherwise "false" if e.g. serving HTTP sitting behind a TLS termination proxy
- config.certificates.host.crt: the ssl host certificate
- config.certificates.host.key: the ssl host certificate private key
- config.sa.sa.properties: the storage area properties file, specifically `rootPath` and `accessPoints`,
- ingress.host: the hostname for ingress via the ingress-nginx controller,
- persistence: attributes to enable persistence of the storage area (should always be enabled!)

Then deploy via Helm the usual way:

```bash
$ helm upgrade --install --create-namespace -n storm-webdav --values values.yaml ska-src-storm-webdav /path/to/ska-src-storm-webdav/etc/helm/
```
