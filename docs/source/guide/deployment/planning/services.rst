########
Services
########


The RSTUF API is a service that exposes a web service. By default, the
container image exposes port ``8080`` or port ``8443`` when
:ref:`using HTTP certificates <guide/repository-service-tuf-api/Docker_README:(Optional) `SECRETS_RSTUF_SSL_CERT\`>`.
Depending upon the specific RSTUF use case, it may become necessary to expose these ports
externally.

The RSTUF Worker is not a service but a workload. No port is exposed.

The :ref:`guide/deployment/planning/deployment:Required Infrastructure Services`
expose their ports depending upon the deployment. Those services are only required to
communicate with the
:ref:`guide/general/introduction:RSTUF Components`.