=========================
Known Issues/Improvements
=========================

The issues are available in the  http://github.com/kaprien

This document is designed for complex and critical issue that
requires discussion


``kaprien-repo-worker`` Scalability
===================================

- `Issue 17 <https://github.com/kaprien/kaprien/issues/17>`_

Suggestions for this problem can be added to the `opened issue <https://github.com/kaprien/kaprien/issues/17>`_.

The scalability works well for ``kaprien-rest-api`` once you can scale
horizontally, having multiple instances of the Server API sending all
requests to the Broker.

The scalability for ``kaprien-repo-worker`` is not functional.

The repository workers pick up the tasks randomly, but it is executed in
order once we use a `lock`.

.. uml::

    @startuml
    !pragma teoz true

    participant "Broker queue" as broker
    participant "kaprien-repo-worker 1" as worker1
    participant "kaprien-repo-worker 2" as worker2
    participant "kaprien-repo-worker 3" as worker3
    participant "kaprien-repo-worker 4" as worker4
    participant "kaprien-repo-worker 5" as worker5

    rnote over broker
    task 01
    task 02
    task 03
    task 04
    task 05
    task 06
    task 07
    task 08
    endrnote

    broker o-> worker1
    note right #cyan: task 01
    &broker o-> worker2
    note right #cyan: task 02
    &broker o-> worker3
    note right #cyan: task 03
    &broker o-> worker4
    note right #cyan: task 04
    &broker o-> worker5
    note right #cyan: task 05

    worker1 --> worker1: run <back:cyan>task 01</back>
    & worker1 -> broker: finish <back:cyan>task 01</back>
    broker o-> worker1
    note right #cyan: task 06

    worker3 --> worker3: run <back:cyan>task 02</back>
    & worker3 -> broker: finish <back:cyan>task 02</back>
    broker o-> worker3
    note right #cyan: task 07

    worker2 --> worker2: run <back:cyan>task 03</back>
    & worker2 -> broker: finish <back:cyan>task 03</back>
    broker o-> worker2
    note right #cyan: task 08

    worker4 --> worker4: run <back:cyan>task 05</back>
    & worker4 -> broker: finish <back:cyan>task 05</back>

    worker5 --> worker5: run <back:cyan>task 04</back>
    & worker5 -> broker: finish <back:cyan>task 04</back>

    worker1 --> worker1: run <back:cyan>task 06</back>
    & worker1 -> broker: finish <back:cyan>task 06</back>

    worker3 --> worker3: run <back:cyan>task 07</back>
    & worker3 -> broker: finish <back:cyan>task 07</back>

    worker2 --> worker2: run <back:cyan>task 08</back>
    & worker2 -> broker: finish <back:cyan>task 08</back>
    @enduml

The problem is the process of writing the role metadata files.

For example, whenever you add a target to a delegated hash role (i.e.
``bins-e``), you need to write a new ``<version>.bins-e.json``, bump the
``<version>.snapshot.json`` and the ``<version>.timestamp``.


.. uml::

    @startuml

    participant "Broker/Backend" as broker
    participant "add-target" as add_target
    participant "Storage Backend" as storage #Grey

    broker o-> add_target: [task 01] <consumer>

    add_target -> storage: loads latest bin-e.json
    add_target <-- storage: 3.bin-e.json
    add_target -> add_target: Add target\nBump version
    add_target -> storage: writes 4.bin-e.json
    note right: 4.bin-e.json\n\tfile001

    add_target -> storage: loads latest Snapshot
    add_target <-- storage: 41.snapshot.json
    add_target -> add_target: Add <bin-e> meta\nbump version
    add_target -> storage: writes  42.snapshot.json
    note right: 4.bin-e.json\n\tfile001\n42.snapshot.json\n\t4.bin-e

    add_target -> storage: loads Timestamp
    add_target <-- storage: Timestamp.json (version 83)
    add_target -> add_target: Add 42.snapshot.json
    add_target -> storage: writes timestamp.json
    note right: 4.bin-e.json\n\t file001\n42.snapshot.json\n\t4.bin-e\ntimestamp.json\n\t42.snapshot.json
    add_target -> broker: [task 01] <publish> result

    @enduml

If you have a hundred or thousand requests to add targets you might have
multiple new ``<version>.bins-e.json`` followed by bumps in ``snapshot`` and
``timestamp``. There is a risk of race conditions.

Exemple

.. uml::

    @startuml

    participant "Broker/Backend" as broker
    participant "add-target" as add_target
    participant "Storage Backend" as storage #Grey

    broker o-[#Blue]> add_target: [task 01] <consuner>
    add_target -[#Blue]> storage: loads latest bin-e.json
    broker o-[#Green]> add_target: [task 02] <consuner>
    add_target -[#Green]> storage: loads latest bin-p.json
    add_target <[#Blue]-- storage: 3.bin-e.json
    add_target <[#Green]-- storage: 16.bin-p.json
    add_target -[#Blue]-> add_target: 3.bin-e.json\n Add target\nBump version to 4
    add_target -[#Green]> add_target: 16.bin-e.json\n Add target\nBump version to 16
    add_target -[#Blue]> storage: writes 4.bin-e.json
    add_target -[#Green]> storage: writes 16.bin-e.json
    note right: 4.bin-e.json\n\tfile001\n16.bin-p.json\n\tfile003\n\tfile005


    add_target -[#Blue]> storage: loads latest Snapshot
    add_target -[#Green]> storage: loads latest Snapshot

    add_target <[#Blue]-- storage: 41.snapshot.json
    add_target <[#Green]-- storage: 41.snapshot.json

    add_target -[#Blue]> add_target: Add <bin-e> meta\nbump version
    add_target -[#Green]> add_target: Add <bin-p> meta\nbump version

    add_target -[#Blue]> storage: writes 42.snapshot.json
    note right: 4.bin-e.json\n\t \
    file001\n16.bin-p.json\n\tfile003\n\tfile005 \
    \n42.snapshot.json\n\t4.bin-e
    add_target -[#Green]-> storage: writes 42.snapshot.json
    destroy storage
    note right#FFAAAA: 4.bin-e.json\n\t \
    file001\n16.bin-p.json\n\tfile003\n\tfile005 \
    \n42.snapshot.json\n\t16.bin-p \
    \n\t**missing 4.bin-e**

    add_target -[#Blue]> storage: loads Timestamp
    add_target -[#Green]> storage: loads Timestamp
    add_target <[#Blue]-- storage: Timestamp.json (version 83)
    add_target -[#Blue]> add_target: Add 42.snapshot.json
    add_target -[#Blue]> storage: writes timestamp.json (version 84)
    note right#FFAAAA: 4.bin-e.json\n\t \
    file001\n16.bin-p.json\n\tfile003\n\tfile005 \
    \n42.snapshot.json\n\t16.bin-p \
    \n\t**missing 4.bin-e** \
    \ntimestamp.json \
    \n\tversion 84 \
    \n\t42.snapshot

    add_target -[#Blue]> broker: [task 01] <publish> result

    add_target <[#Green]-- storage: Timestamp.json (version 84)
    add_target -[#Green]> add_target: Add 42.snapshot.json
    add_target -[#Green]> add_target: Add target\nBump version to 85
    add_target -[#Green]> storage: writes timestamp.json (version 85)
    note right#FFAAAA: 4.bin-e.json\n\t \
    file001\n16.bin-p.json\n\tfile003\n\tfile005 \
    \n42.snapshot.json\n\t16.bin-p \
    \n\t**missing 4.bin-e** \
    \ntimestamp.json \
    \n\tversion 84 \
    \n\t42.snapshot
    add_target -[#Green]> broker: [task 02] <publish> result

    @enduml

On one level, we optimize it `by grouping all changes for the same delegated hash
role <https://github.com/kaprien/kaprien-repo-worker/blob/6ad68ec6d898315fcc42bcddd198619f07618d5e/repo_worker/tuf/repository.py#L173>`_
, avoiding multiple interactions in the same task.

However we still have a problem with the snapshot and ``timestamp``.
To avoid the problem, we use a lock system with one task per time.

The lock protects against the race condition but does not solve the
scalability. Even having dozen ``kaprien-repo-worker`` do not scale the
writing metadata process.

.. uml::

    @startuml
    !pragma teoz true

    participant "Broker/Backend" as broker
    participant "add-target" as add_target
    participant "Storage Backend" as storage #Grey

    broker o-[#Blue]> add_target: [task 01] <consuner>
    note left #Red: Lock
    add_target -[#Blue]> add_target: check lock

    broker o-[#Green]> add_target: [task 02] <consuner>
    add_target -[#Green]> add_target: check lock
    note left #Orange: Waiting unlock

    group "task 01" execution
    add_target -[#Blue]> storage: loads latest bin-e.json
    add_target <[#Blue]-- storage: 3.bin-e.json
    add_target -[#Blue]-> add_target: 3.bin-e.json\n Add target\nBump version to 4
    add_target -[#Blue]> storage: writes 4.bin-e.json
    add_target -[#Blue]> storage: loads latest Snapshot
    add_target <[#Blue]-- storage: 41.snapshot.json
    add_target -[#Blue]> add_target: Add <bin-e> meta\nbump version
    add_target -[#Blue]> storage: writes 42.snapshot.json
    add_target -[#Blue]> storage: loads Timestamp
    add_target <[#Blue]-- storage: Timestamp.json (version 83)
    add_target -[#Blue]> add_target: Add 42.snapshot.json
    add_target -[#Blue]> storage: writes timestamp.json (version 84)
    note right: 4.bin-e.json\n\tfile001 \
    \n42.snapshot.json\n\t4.bin-e \
    \ntimestamp.json (version: 84) \
    \n\t42.snapshot
    {finish_task01} add_target -[#Blue]> broker: [task 01] <publish> result
    note left #Cyan: Unlock
    end

    add_target -[#Green]> broker: [task 02] Lock
    note left #Red: Lock

    group "task 02" execution
    add_target <[#Green]-- storage: 16.bin-p.json
    add_target -[#Green]> add_target: 16.bin-e.json\n Add target\nBump version to 16
    add_target -[#Green]> storage: writes 16.bin-e.json
    add_target -[#Green]> storage: loads latest Snapshot
    add_target <[#Green]-- storage: 42.snapshot.json
    add_target -[#Green]> add_target: Add <bin-p> meta\nbump version
    add_target -[#Green]> storage: loads Timestamp
    add_target <[#Green]-- storage: Timestamp.json (version 84)
    add_target -[#Green]> add_target: Add 43.snapshot.json
    add_target -[#Green]> add_target: Add target\nBump version to 85
    add_target -[#Green]> storage: writes timestamp.json (version 85)
    note right: 16.bin-p.json\n\tfile003\n\tfile005 \
    \n43.snapshot.json\n\t4.bin-e \n\t16.bin-p \
    \ntimestamp.json (version 85) \
    \n\t43.snapshot
    add_target -[#Green]> broker: [task 02] <publish> result
    note left #Cyan: Unlock
    end
    @enduml

The best scenario:

.. uml::

    @startuml
    !pragma teoz true

    participant "Broker queue" as broker
    participant "kaprien-repo-worker 1" as worker1
    participant "kaprien-repo-worker 2" as worker2
    participant "kaprien-repo-worker 3" as worker3
    participant "kaprien-repo-worker 4" as worker4
    participant "kaprien-repo-worker 5" as worker5

    rnote over broker
    task 01
    task 02
    task 03
    task 04
    task 05
    task 06
    task 07
    task 08
    endrnote

    broker o-> worker1
    note right #cyan: task 01
    &broker o-> worker2
    note right #cyan: task 02\ttask06
    &broker o-> worker3
    note right #cyan: task 03\ttask04
    &broker o-> worker4
    note right #cyan: task 05\ttask07
    &broker o-> worker5
    note right #cyan: task08

    worker1 --> worker1: run <back:cyan>task 01</back>
    & worker1 -> broker: finish <back:cyan>task 01</back>

    worker2 --> worker2: run <back:cyan>task 02\ttask 06</back>
    & worker2 --> worker2: run <back:cyan>task 06</back>
    & worker2 -> broker: finish <back:cyan>task 02\ttask 06</back>

    worker4 --> worker4: run <back:cyan>task 05</back>
    & worker4 -> broker: finish <back:cyan>task 05</back>
    &worker5 --> worker5: run <back:cyan>task 05</back>
    & worker5 -> broker: finish <back:cyan>\t\ttask 08</back>

    worker3 --> worker3: run <back:cyan>task 03</back>
    & worker3 -> broker: finish <back:cyan>task 03</back>
    worker3 --> worker3: run <back:cyan>task 04</back>
    & worker3 -> broker: finish <back:cyan>task 04</back>

    worker4 --> worker4: run <back:cyan>task 07</back>
    & worker4 -> broker: finish <back:cyan>task 07</back>
    @enduml

Suggestions for this problem can be added to the `opened issue <https://github.com/kaprien/kaprien/issues/17>`_.