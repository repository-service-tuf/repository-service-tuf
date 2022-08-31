===========
Kaprien CLI
===========

``kaprien`` is a Command Line Interface for Kaprien Server.

Installation
============

Using pip:

.. code:: shell

    $ pip install kaprien


Administration (``admin``)
==========================

It executes administrative commands to the Kaprien Server.

.. code:: shell

    ❯ kaprien admin

    Usage: kaprien admin [OPTIONS] COMMAND [ARGS]...

    Administrative Commands

    ╭─ Options ────────────────────────────────────────────────────────────────────────────╮
    │  --help  -h    Show this message and exit.                                           │
    ╰──────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ───────────────────────────────────────────────────────────────────────────╮
    │  ceremony  Start a new Metadata Ceremony.                                            │
    │  login     Login to Kaprien Server (API).                                            │
    │  token     Token Management.                                                         │
    ╰──────────────────────────────────────────────────────────────────────────────────────╯


Login to Server (``login``)
---------------------------

This command will log in to Kaprien Server and give you a token to run other commands such as Ceremony, Token Generation, etc.

.. code:: shell

    ❯ kaprien admin login
    ╔══════════════════════════════════════════════════════════════════════════════════════╗
    ║                                     Login to Kaprien Serve                           ║
    ╚══════════════════════════════════════════════════════════════════════════════════════╝

    ┌──────────────────────────────────────────────────────────────────────────────────────┐
    │         The server and token will generate a token and it will be                    │
    │         stored in /Users/kairoaraujo/.kaprien.ini                                    │
    └──────────────────────────────────────────────────────────────────────────────────────┘

    Server Address: http://192.168.1.199
    Username (admin): admin
    Password:
    Expire (in hours): 2
    Token stored in /Users/kairoaraujo/.kaprien.ini

    Login successfuly.


Ceremony (``ceremony``)
-----------------------

The Kaprien Metadata uses the following Roles: ``Root``, ``Timestamp``,
``Snapshot``, ``Targets``, ``bin``, and ``bins`` to build the Repository
Metadata. (For more details, check out TUF Specification and PEP 458)

The Ceremony is a complex process that Kaprien CLI tries to simplify.
You can do the Ceremony offline. It means on a disconnected computer
(recommended once you will manage the keys).


.. code:: shell

    ❯ kaprien admin ceremony --help
                                                                                                                            
    Usage: kaprien admin ceremony [OPTIONS]                                                                                  
                                                                                                                            
    Start a new Metadata Ceremony.                                                                                           
                                                                                                                            
    ╭─ Options ──────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │  --bootstrap  -b        Bootstrap a Kaprien Server using the Repository Metadata after Ceremony                        │
    │  --file       -f  TEXT  Generate specific JSON Payload compatible with Kaprien Server bootstrap after Ceremony         │
    │                         [default: payload.json]                                                                        │
    │  --upload     -u        Upload existent payload 'file'. Requires '-b/--bootstrap'. Optional '-f/--file' to use non     │
    │                         default file.                                                                                  │
    │  --save       -s        Save a copy of the metadata localy. This option saves the metadata files (json) in the         │
    │                         'metadata' dir.                                                                                │
    │                         [default: False]                                                                               │
    │  --help       -h        Show this message and exit.                                                                    │
    ╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

There are three steps in the Ceremony

.. note::

    We recommend running the ``kaprien admin ceremony`` to simulate and check
    the details of the instructions. It is more detailed.


Step 1: Configure the Roles
...........................

.. code:: shell

    ❯ kaprien admin ceremony

    (...)
    Do you want start the ceremony? [y/n]: y
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                         STEP 1: Configure the Roles                          ║
    ╚══════════════════════════════════════════════════════════════════════════════╝

    The TUF roles supports multiple keys and the threshold (quorun trust) defines   
    the minimal number of the keys required to take actions using specific Role.    

    Reference: TUF                                                                  

    What Metadata expiration for root role?(Days) (356):  
    What is the number of keys for root role? (2): 
    What is the key threshold for root role signing? (1): 

    What Metadata expiration for targets role?(Days) (365): 
    What is the number of keys for targets role? (2): 
    What is the key threshold for targets role signing? (1): 
    The role targets delegates paths to bin role. See TUF Specification about Path Pattern for the paths
    pattern and the example.                                                                            
    Show example [y/n] (y): y

                                                Example:                                              

    The Organization Example (https://example.com) has all files downloaded /downloads path, meaning    
    https://example.com/downloads/.                                                                     

    Additionally it has two sub-folders, productA and productB where the clients can find all files     
    (i.e.: productA-v1.0.tar, productB-1.0.tar), for productBit has even a sub-folder, updates where    
    clients can find update files (i.e.: servicepack-1.tar, servicepack-2.tar)                          

    In that case mapping all targets files paths as:                                                    

    • https://example.com/downloads/ is *                                                              
    • https://example.com/downloads/productA/ is */*                                                   
    • https://example.com/downloads/productB/ is */* (same as above)                                   
    • https://example.com/downloads/productB/updates/ is */*/*                                         

    Specific paths that role targets delegates are: */productA/*, */productB/*, * /productB/updates/*   

    Generic paths that role targets delegates are: *, */*, */*/*                                        

    What is the Base URL (i.e.: https://www.example.com/downloads/): https://www.example.com/downloads/

    What paths targets delegates? (*, */*): *, */*, */*/*

    What Metadata expiration for snapshot role?(Days) (1): 
    What is the number of keys for snapshot role? (1): 
    The threshold for snapshot is 1 (one) based on the number of keys (1).

    What Metadata expiration for timestamp role?(Days) (1): 
    What is the number of keys for timestamp role? (1): 
    The threshold for timestamp is 1 (one) based on the number of keys (1).

    What Metadata expiration for bin role?(Days) (365): 
    What is the number of keys for bin role? (1): 
    The threshold for bin is 1 (one) based on the number of keys (1).

    What Metadata expiration for bins role?(Days) (1): 
    What is the number of keys for bins role? (1): 
    The threshold for bins is 1 (one) based on the number of keys (1).
    Number of hashed bins for bins? (8): 


1. Root ``expiration``, ``number of keys``, and ``threshold``
2. Targets ``expiration``, ``number of keys``,  ``threshold``, the ``base URL``
   for the files (target files), and the ``paths``
3. Snapshot ``expiration``, ``number of keys``, and ``threshold``
4. Timestamp ``expiration``, ``number of keys``, and ``threshold``
5. Bin ``expiration``, ``number of keys``, and ``threshold``
6. Bins ``expiration``, ``number of keys``, ``threshold``, and ``number of hash bins``

- ``expiration`` is the number of days that Metatada will expire
- ``number of keys`` Metadata will have
- ``threshold`` is number of keys needed to sign the Metadata
- ``base URL`` for the artifacts, example: http://www.example.com/download/
- ``paths`` is the delegated paths, example:
  http://www.example.com/download/productA/* will be ``*, */*``
- ``number of hash bins`` is the number of hash bins between 1 and 32. How many
  delegated roles (``bins-X``) will it create?

Step 2: Loading the Keys
........................

It is essential to define the Key Owners. There is a suggestion in the CLI.

The owners will need to be present to share the key and use their password to
load the keys.

.. code:: shell

    ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
    ║                                     STEP 2: Load roles keys                                      ║
    ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

    The keys must to have a password and the file must to be accessible.                                

    Depending of the Organization, each key has an owner. During the the key loading process is         
    important that the owner of the key insert the password.                                            

    The password or the key content is not shown in the screen.                                         

    Ready to start loading the keys? Passwords will be required for keys [y/n]: y

    Enter 1/2 the root`s Key path: tests/files/JanisJoplin.key
    Enter 1/2 the root`s Key password: 
    ✅ Key 1/2 Verified

    Enter 2/2 the root`s Key path: tests/files/JimiHendrix.key
    Enter 2/2 the root`s Key password: 
    ✅ Key 2/2 Verified

    Enter 1/2 the targets`s Key path: tests/files/KurtCobain.key
    Enter 1/2 the targets`s Key password: 
    ✅ Key 1/2 Verified

    Enter 2/2 the targets`s Key path: tests/files/ChrisCornel.key
    Enter 2/2 the targets`s Key password: 
    ✅ Key 2/2 Verified

    Enter 1/1 the snapshot`s Key path: tests/files/snapshot1.key
    Enter 1/1 the snapshot`s Key password: 
    ✅ Key 1/1 Verified

    Enter 1/1 the timestamp`s Key path: tests/files/timestamp1.key
    Enter 1/1 the timestamp`s Key password: 
    ✅ Key 1/1 Verified

    Enter 1/1 the bin`s Key path: tests/files/JoeCocker.key
    Enter 1/1 the bin`s Key password: 
    ✅ Key 1/1 Verified

    Enter 1/1 the bins`s Key path: tests/files/bins1.key
    Enter 1/1 the bins`s Key password: 
    ✅ Key 1/1 Verified


Step 3: Validate the information/settings
.........................................

After confirming all details, the initial payload for bootstrap will be
complete (without the offline keys).

.. code:: shell

    ╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
    ║                                  STEP 3: Validate configuration                                  ║
    ╚══════════════════════════════════════════════════════════════════════════════════════════════════╝

    The information below is the configuration done in the preview steps. Check the number of keys, the 
    threshold/quorun and type of key.                                                                   
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃       ROLE SUMMARY        ┃                                 KEYS                                 ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │        Role: root         │                   ╷                                     ╷            │
    │     Number of Keys: 2     │              path │                 id                  │ verified   │
    │       Threshold: 1        │ ╶─────────────────┼─────────────────────────────────────┼──────────╴ │
    │    Keys Type: offline     │   JanisJoplin.key │ 1cebe343e35f0213f6136758e6c3a8f8e1… │    ✅      │
    │ Role Expiration: 356 days │   JimiHendrix.key │ 800dfb5a1982b82b7893e58035e19f414f… │    ✅      │
    │                           │                   ╵                                     ╵            │
    └───────────────────────────┴──────────────────────────────────────────────────────────────────────┘
    Configuration correct for root? [y/n]: y
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃              ROLE SUMMARY               ┃                          KEYS                          ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │              Role: targets              │                   ╷                       ╷            │
    │            Number of Keys: 2            │              path │          id           │ verified   │
    │              Threshold: 1               │ ╶─────────────────┼───────────────────────┼──────────╴ │
    │           Keys Type: offline            │    KurtCobain.key │ 208fc4139cf7482abbe8… │    ✅      │
    │        Role Expiration: 365 days        │   ChrisCornel.key │ c2e9ee4a292e5d08bc0d… │    ✅      │
    │                                         │                   ╵                       ╵            │
    │                                         │                                                        │
    │                                         │                                                        │
    │               DELEGATIONS               │                                                        │
    │             targets -> bin              │                                                        │
    │   https://www.example.com/downloads/*   │                                                        │
    │  https://www.example.com/downloads/*/*  │                                                        │
    │ https://www.example.com/downloads/*/*/* │                                                        │
    └─────────────────────────────────────────┴────────────────────────────────────────────────────────┘
    Configuration correct for targets? [y/n]: y
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃      ROLE SUMMARY       ┃                                  KEYS                                  ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │     Role: snapshot      │                 ╷                                         ╷            │
    │    Number of Keys: 1    │            path │                   id                    │ verified   │
    │      Threshold: 1       │ ╶───────────────┼─────────────────────────────────────────┼──────────╴ │
    │    Keys Type: online    │   snapshot1.key │ 139c406ac6150598fb9f7cafd1463bc07e0318… │    ✅      │
    │ Role Expiration: 1 days │                 ╵                                         ╵            │
    └─────────────────────────┴────────────────────────────────────────────────────────────────────────┘
    Configuration correct for snapshot? [y/n]: y
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃      ROLE SUMMARY       ┃                                  KEYS                                  ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │     Role: timestamp     │                  ╷                                        ╷            │
    │    Number of Keys: 1    │             path │                   id                   │ verified   │
    │      Threshold: 1       │ ╶────────────────┼────────────────────────────────────────┼──────────╴ │
    │    Keys Type: online    │   timestamp1.key │ 19f5992640ab71f49fb64d5b5d198ee0115c3… │    ✅      │
    │ Role Expiration: 1 days │                  ╵                                        ╵            │
    └─────────────────────────┴────────────────────────────────────────────────────────────────────────┘
    Configuration correct for timestamp? [y/n]: y
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃       ROLE SUMMARY        ┃                                 KEYS                                 ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │         Role: bin         │                 ╷                                       ╷            │
    │     Number of Keys: 1     │            path │                  id                   │ verified   │
    │       Threshold: 1        │ ╶───────────────┼───────────────────────────────────────┼──────────╴ │
    │    Keys Type: offline     │   JoeCocker.key │ be95ae808ff4f17e248470c941700247d8c7… │    ✅      │
    │ Role Expiration: 365 days │                 ╵                                       ╵            │
    └───────────────────────────┴──────────────────────────────────────────────────────────────────────┘
    Configuration correct for bin? [y/n]: y
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃      ROLE SUMMARY       ┃                                  KEYS                                  ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │       Role: bins        │             ╷                                             ╷            │
    │    Number of Keys: 1    │        path │                     id                      │ verified   │
    │      Threshold: 1       │ ╶───────────┼─────────────────────────────────────────────┼──────────╴ │
    │    Keys Type: online    │   bins1.key │ 9b2a880bd470e8373e24efb0dc54df3909e180e445… │    ✅      │
    │ Role Expiration: 1 days │             ╵                                             ╵            │
    │                         │                                                                        │
    │                         │                                                                        │
    │       DELEGATIONS       │                                                                        │
    │      bins -> bins       │                                                                        │
    │     Number bins: 8      │                                                                        │
    └─────────────────────────┴────────────────────────────────────────────────────────────────────────┘

Finishing
.........

If you choose ``-b/--bootstrap`` it will automatically send the bootstrap to
``kaprien-rest-api``, no actions necessary

If you did the ceremony in a disconnected computer.
Using another computer with access to ``kaprien-rest-api``.
1.  Get the generated ``payload.json`` (or the custom name you choose).
2.  Install ``kaprien-cli``
3.  Run ``kaprien admin ceremony -b [-u filename]``

Token (``token``)
-----------------

Token Management

.. code:: shell

    ❯ kaprien admin token
                                                                                                                            
    Usage: kaprien admin token [OPTIONS] COMMAND [ARGS]...                                                                   
                                                                                                                            
    Token Management.                                                                                                        
                                                                                                                            
    ╭─ Options ──────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │  --help  -h    Show this message and exit.                                                                             │
    ╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ─────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │  generate  Generate new token.                                                                                         │
    │  inspect   Show token information details.                                                                             │
    ╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

``generate``
............
Generate tokens to use in integrations

.. code:: shell

    ❯ kaprien admin token generate -h
                                                                                                        
    Usage: kaprien admin token generate [OPTIONS]                                                      
                                                                                                        
    Generate new token.                                                                                
                                                                                                        
    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────╮
    │     --expires  -e  INTEGER  Expires in hours. Default: 24 [default: 24]                          │
    │  *  --scope    -s  TEXT     Scope to grant. Multiple is accepted. Ex: -s write:targets -s        │
    │                             read:targets                                                         │
    │                             [required]                                                           │
    │     --help     -h           Show this message and exit.                                          │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────╯

Example of usage:

.. code:: shell

    ❯ kaprien admin token generate -s write:targets
    {
        "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyX
        zFfNTNiYTY4MzAwNTk3NGY2NWIxMDQ5NzczMjIiwicGFzc3dvcmQiOiJiJyQyYiQxMiRxT0
        5NRjdRblI3NG0xbjdrZW1MdFJld05MVDN2elNFLndsRHowLzBIWTJFaGxpY05uaFgzdSci
        LCJzY29wZXMiOlsid3JpdGU6dGFyZ2V0cyJdLCJleHAiOjE2NjIyODExMDl9.ugwibyv8H
        -zVgGgRfliKgUgHZrZzeJDeAw9mQJrYLz8"
    }

This token can be use with Github Secrets, Jenkins Secrets, CircleCI, shell
script, etc

``inspect``
...........

Show token detailed information.

.. code:: shell

    ❯ kaprien admin token inspect -h
                                                                                                                            
    Usage: kaprien admin token inspect [OPTIONS] TOKEN                                                                       
                                                                                                                            
    Show token information details.                                                                                          
                                                                                                                            
    ╭─ Options ──────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │  --help  -h    Show this message and exit.                                                                             │
    ╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

    ❯ kaprien admin token inspect eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1...PDwwY
    {
    "data": {
        "scopes": [
        "write:targets"
        ],
        "expired": false,
        "expiration": "2022-09-04T08:42:44"
    },
    "message": "Token information"
    }