=================================================
Repository Service for TUF REST API Documentation
=================================================

API Authentication and Authorization
====================================

The ``admin`` user can request a token using the Authentication endpoint
``api/v1/token/``. The API will give the token with expiration (in hours).
The Default is 1 (hour).

.. uml::

    @startuml
        User -> API: Auth Request Token
        API -> API: validates token
        API -> User: Response with Token
    @enduml

A valid token, with scope ``write:token`` can also request tokens using the
Rest API endpoint ``api/v1/token/new``.

.. uml::

    @startuml
        User -> API: HTTP Request Token with Token (token/new)
        API -> API: Validates scope 'write:token'
        API -> User: Response with Token
    @enduml

.. warning::

    All endpoints require a valid token that contains the required scope.

    .. uml::

        @startuml
            User -> API: HTTP Request HEADERS with Token
            API -> API:validates token
            API -> User: Response content
        @enduml

.. note::

    Please check the Repository Service for TUF CLI

    .. code:: shell

        $ repository-service-tuf admin token

API Endpoints
=============

The REST API Swagger Documentation is available after the Deploy
(http://ip-address/)


.. note::

    This documentation has limited information. We recommend access the API
    documentation available in the service.


.. openapi:: api/swagger.json