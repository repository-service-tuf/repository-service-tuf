#######################
Kubernetes (Helm Chart)
#######################

RSTUF provides a Helm Chart to deploy the RSTUF API and Worker in a Kubernetes Cluster.

This guide shows how to deploy RSTUF using Helm Chart in a Kubernetes Cluster.

The Helm Chart is available in the https://repository-service-tuf.github.io/helm-charts/ repository.

Requirements
############

Software and tools
==================

  * Kubernetes Cluster
  * kubectl
  * Helm

Using Helm Chart
################

Add the Helm Chart repository:

.. code:: shell

    ❯ helm repo add rstuf https://repository-service-tuf.github.io/helm-charts

Update the Helm Chart repository:

.. code:: shell

    ❯ helm repo update


Search the Helm Chart:

.. code:: shell

    ❯ helm search repo rstuf
    NAME                    CHART VERSION   APP VERSION     DESCRIPTION
    rstuf/rstuf-api         0.2.0           1.0.0b1         A RSTUF API Helm chart for Kubernetes
    rstuf/rstuf-worker      0.2.0           1.0.0b1         A RSTUF Worker Helm chart for Kubernetes


Example of ``values.yaml``
##########################

This example deploys:

- RSTUF API
- RSTUF Worker
- Valkey
- PostgreSQL database

.. literalinclude:: helm/values.yaml
    :language: yaml
    :linenos:
    :name: values.yml