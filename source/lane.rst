.. Local Area Network Emulation Service

Local Area Network Emulation Service
====================================

This service provides local area :term:`network emulation` (LANE) for its
connected clients.  Every client is given a unique address within the address
space available to the server.  For example, if the server was providing
Ethernet Local Area Network Emulation (ELANE) then each client would be given
an Ethernet 6-octet address.

The size of the address space is a configuration property of the server.  It
must be at least 1-octet which would be similar to an MS/TP or ARCNET LAN, and
addresses longer than 6-octets may not be supported by BACnet devices.

The server is also configured with a BACnet network number that is unique in
the BACnet intranet.  It may be a *standalone server* which is not functioning
as a router.  If it is functioning as a router, then at least one of the
addresses in the address space available to the server will be reserved to
be the address of the router to the BACnet intranet.

After authentication, if the server does not provide the LANE Service then it
will send a :ref:`service-request-result` with the error code
NO_LANE_SERVICE.

.. note::

   This is now more commonly referred to as a *virtual network* and the
   addresses assigned by the server are *virtual MAC addresses*.

Protocol Data Units
-------------------

Packets from the LANE server to the connected clients will have the
SNET/SLEN/SADR fields present.  The DNET/DLEN/DADR fields may also be present
if the packet was broadcast, in this case the DLEN will always be zero and the
DADR empty octet string.

Packets from a client to its connected server will have the DNET/DLEN/DADR
fields present.

.. _client-to-server-unicast-request:

LANE Client to Server Unicast Request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This packet is sent by a client to the server to request that the server send
the request to a BACnet address on behalf of the client.  The request 
payload is restricted to unicast messages.

The DNET/DLEN/DADR fields of the NPCI will be present, even if the destination
is the BACnet network being emulated by the server.

.. csv-table:: **Table X.16** LANE Client to Server Unicast Request Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "LANE Client to Server Unicast Request (value = X'0B')"
   "BSLV Length", "2-octets", "Length"
   "Payload", "variable", "Application PDU"

.. _client-to-server-broadcast-request:

LANE Client to Server Broadcast Request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This packet is sent by a client to the server to request that the server
broadcast the request on the network emulated by the server in the case of
a local broadcast or global broadcast message, or in the case of a remote
network broadcast, send the request as a unicast message to the router
responsible for the destination network.  The request payload is restricted to
broadcast messages.

The DNET/DLEN/DADR fields of the NPCI will be present.  If the destination
is to be considered a local broadcast by the LANE server, then the DNET
will be the network emulated by server.  In all cases the DLEN will be
zero and the DADR will be the empty octet string.

.. csv-table:: **Table X.17** LANE Client to Server Request Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "LANE Client to Server Broadcast Request (value = X'0C')"
   "BSLV Length", "2-octets", "Length"
   "Payload", "variable", "Application PDU"

.. _server-to-client-unicast-request:

LANE Server to Client Unicast Request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This packet is a forwarded copy of a unicast message received by the server
to the client.  The request payload is restricted to unicast messages.

The SNET/SLEN/SADR fields of the NPCI will be present, even if the destination
is the same BACnet network emulated by the server.  The DNET/DLEN/DADR fields
of the NPCI will be absent.

.. csv-table:: **Table X.18** LANE Server to Client Unicast Request Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "LANE Server to Client Unicast Request (value = X'0D')"
   "BSLV Length", "2-octets", "Length"
   "Payload", "variable", "Application PDU"

.. _server-to-client-broadcast-request:

LANE Server to Client Broadcast Request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This packet is a forwarded copy of a broadcast message received by the server
to the client.  The request payload is restricted to broadcast messages.

The SNET/SLEN/SADR fields of the NPCI will be present, even if the destination
is on the same BACnet network emulated by server.

The DNET/DLEN/DADR fields of the NPCI will be present.  If the destination
was a local broadcast when it was received by the server, then the DNET
will be the network emulated by the server.  In all cases the DLEN will be
zero and the DADR will be the empty octet string.

.. csv-table:: **Table X.19** LANE Server to Client Request Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "LANE Server to Client Broadcast Request (value = X'0E')"
   "BSLV Length", "2-octets", "Length"
   "Payload", "variable", "Application PDU"
