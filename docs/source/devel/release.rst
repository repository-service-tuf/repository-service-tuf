======================================
TUF Repository Service Release process
======================================

Release process
===============

The Components track the Release Issues using the GitHub Milestones for the
Component Repository.

The Components have autonomy on their release, and the process follows the
same for all components.
The versioning follows ``X.Y.Z`` where ``X`` is the major version, ``Y`` is the
minor version, and ``Z`` is the micro version:

    - New major versions are exceptional; they only come when strongly
      incompatible changes are deemed necessary and are planned very long in
      advance;
    - New minor versions are feature releases; they get released accordingly
      with some Roadmap;
    - New micro versions are bugfix releases;

The Component decides to release alphas (``vX.Y.ZaN`` where``N`` is incremental
release/build) and betas (``vX.Y.ZbN``).

Releasing
---------

1. To release, a tag ``vX.Y.Z`` is created.
2. This tag will trigger the ``.github/workflow/cd.yml`` that will generate a
   new artifact (Package or Docker Image) with the tag and name ``rc``.
   Example: ``v0.1.3-rc``. This artifact is a release candidate for tests and
   validations.
3. After tests and validation, one of the maintainers needs to approve, and the
   artifact will be General Available (GA).

.. uml::

    @startuml
        start
        :New tag v1.2.3;
        if (Run CD) then (success)
            :Generate artifact v1.2.3rc;
            if (Maintainer Approval) then (Approved)
                :Release Artifact v1.2.3;
                stop
            else (reject)
                end
            endif
        else (failure)
            end
        endif
    @enduml

Roadmap
=======

.. toctree::
   :maxdepth: 2

   roadmap