########
Services
########


The RSTUF API is a service that exposes a web service. By default, the
container image exposes port ``80`` or port ``443`` when
:ref:`using HTTP certificates <guide/repository-service-tuf-api/Docker_README:(Optional) `SECRETS_RSTUF_SSL_CERT\`>`.
Depending on your RSTUF use case, you might need to expose these ports
externally.

The RSTUF Worker is not a service but a workload. No port exposed.

The :ref:`guide/deployment/planning/deployment:Required Infrastructure Services`
expose its ports depending on the deployment. Those services are required to
communicate only with the
:ref:`guide/general/introduction:RSTUF Components`.