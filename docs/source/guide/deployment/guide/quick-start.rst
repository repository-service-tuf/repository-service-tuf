#############################
Quick Start (Demo deployment)
#############################

This guide provides a quick start to deploy RSTUF in a demo environment.
This deployment will use Docker, Helm Chart, and Minikube for running a Kubernetes cluster locally.

Requirements
############

Software and tools
==================

  * `Docker <https://www.docker.com>`_
  * `Helm Chart <https://helm.sh/docs/intro/install/>`_
  * `Minikube <https://minikube.sigs.k8s.io/docs/start/>`_
  * `kubectl <https://kubernetes.io/docs/tasks/tools/install-kubectl/>`_
  * Python >= 3.10
  * pip

Make sure you have all the required software and tools installed.

RSTUF running in using 4 steps (demo mode)
##########################################

1. Get RSTUF helm chart
=======================

.. code:: shell

    ❯ helm repo add rstuf https://repository-service-tuf.github.io/helm-charts

    ❯ helm repo update

    ❯ helm search repo rstuf
    NAME                    CHART VERSION   APP VERSION     DESCRIPTION
    rstuf/rstuf-api         0.2.0           1.0.0b1         A RSTUF API Helm chart for Kubernetes
    rstuf/rstuf-demo        0.2.0           1.0.0b1         RSTUF Demo deploying RSTUF services and infrast...
    rstuf/rstuf-worker      0.2.0           1.0.0b1         A RSTUF Worker Helm chart for Kubernetes

2. Start minikube including the ingress addon
=============================================

.. code:: shell

    ❯ minikube start --driver=docker
    ❯ minikube addons enable ingress
    ❯ minikube addons enable ingress-dns


3. Deploy RSTUF demo
====================

.. code:: shell

    ❯ helm upgrade --install rstuf rstuf/rstuf-demo -n rstuf --create-namespace
    Release "rstuf" does not exist. Installing it now.
    NAME: rstuf
    LAST DEPLOYED: Sat Sep 28 10:37:08 2024
    NAMESPACE: rstuf
    STATUS: deployed
    REVISION: 1

Check if the pods are all running

.. code:: shell

    ❯ kubectl get pod -n rstuf
    NAME                                  READY   STATUS    RESTARTS      AGE
    rstuf-localstack-5c9b844668-w9rqq     1/1     Running   0             2m10s
    rstuf-postgresql-0                    1/1     Running   0             2m10s
    rstuf-rstuf-api-69b689dff5-c5wh7      1/1     Running   1 (29s ago)   2m10s
    rstuf-rstuf-worker-84957d95b7-msbzl   1/1     Running   1 (14s ago)   2m10s
    rstuf-valkey-master-0                 1/1     Running   0             2m10s

4. Minikube tunnel
==================

.. code:: shell

    ❯ minikube tunnel
    ✅  Tunnel successfully started

    📌  NOTE: Please do not close this terminal as this process must stay alive for the tunnel to be accessible ...

    ❗  The service/ingress rstuf-localstack requires privileged ports to be exposed: [80 443]
    🔑  sudo permission will be asked for it.
    ❗  The service/ingress rstuf-rstuf-api requires privileged ports to be exposed: [80 443]
    🏃  Starting tunnel for service rstuf-localstack.
    🔑  sudo permission will be asked for it.
    🏃  Starting tunnel for service rstuf-rstuf-api.
    Password:


RSTUF API is available in http://rstuf.localhost

You can go through the RSTUF setup ceremony and bootstrap,
see :ref:`guide/deployment/setup:Service Setup`.

And that's it! You have RSTUF running in your local machine,
see how to use it in :ref:`guide/general/usage:Using RSTUF`.