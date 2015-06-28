.. Streaming BACnet documentation master file

Streaming BACnet
================

Rationale
---------

This addenda is a specification for sending and receiving PDU’s between
networking entities when they use a :term:`connection-oriented protocol`.

This specification is not restricted to a specific protocol such as TCP, nor
does it preclude the use of protocols that also provide security services
such as SSL.

.. note::

   I have been using **BACnet/TCP** to refer to Streaming BACnet over TCP
   connections to differentiate it from BACnet/IP which is UDP.  I expect
   servers to be listening on port 47808.

This design follows the model of the BACnet Virtual Link Layer established in
Annex J.  Connection oriented protocols provide a continuous stream of content
between endpoints and there is no proscribed boundary between packets, so a
BACnet Streaming Link Layer (BSLL) header is used to divide the stream into
PDU’s (this is considered a presentation layer function in the OSI model).

BSLL Protocol Data Units
~~~~~~~~~~~~~~~~~~~~~~~~

The BSLL header has a one octet type field, a one octet function field,
and two octet length field.  The maximum data length to be 65531 octets.
To distinguish these BSLL packets from those in Annex J, the type field
contains X’82’.

.. csv-table:: **Table X.1** BSLL Message Fields
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "Function"
   "BSLV Length", "2-octets", "Length L, in octets, of the BSLL message and its contents"
   "Payload", "variable", "Dependent on the function"

Network Entities
----------------

There are a three network entities in BACnet; devices, routers, and BBMDs.
Similar to the way a physical BACnet devices can be any combination of the 
three types, for example a device can also be a router, the new network
entities in this specification can be combined together.

Packets from any of the services may be used in a connection, for
example, routers typically have a device object and are therefore considered
to be a device as well as a router.  If a device is connected to a router that
has a device object, it is not necessary to establish a separate connection
for device-to-device traffic to separate it from device-to-router traffic.  It
is, however, required that the client request the connection be used for the
service.

Services
--------

.. toctree::
   :maxdepth: 2
   
   session.rst
   device-to-device.rst
   router-to-router.rst
   proxy.rst
   lane.rst

Glossary
--------

.. toctree::
    :maxdepth: 2

    glossary.rst

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
