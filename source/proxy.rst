.. Proxy Service

Proxy Service
=============

The proxy functionality provides a mechanism for a device to participate in a
BACnet intranet that cannot use connectionless protocols in peer-to-peer or
broadcast exchanges of PDU’s, either because it is impossible, due to firewall
restrictions, or impractical, perhaps due to the complexity of configuring all
of the intermediate networking equipment.

A proxy server is conceptually like a "port extender."  It has a BACnet
address on an interface on a BACnet network, and similar to a router, knows the
network number of its interface.  As a BSLL server it provides a listener for
connected clients.  For example, it may have UDP port 47808 open and
additionally be listening for clients on TCP port 47808.

After authentication, if the server does not provide the Proxy Service then it
will send a :ref:`service-request-result` with the error code
NO_PROXY_SERVICE.

After a proxy client initiates a session with a server, the server will
forward all PDU’s from the client to network and vice versa.  BACnet
functionality is provided by client.  A proxy server does not provide any
BACnet services without a connected proxy client.

There are two types of proxy servers; those that are limited to supporting a
single client, and those that support multiple clients.

Single Client Proxy Service
---------------------------

A proxy server that is limited to supporting a single client forwards all
BACnet traffic that it receives to the client and vice versa.  It may
additionally cache network topology information, such as the addresses routers
and their connected networks to facilitate path discovery on behalf of clients.

Multiple Client Proxy Service
-----------------------------

In addition to caching network topology information like a single client
proxy server, a proxy server that supports multiple clients may provide
additional functionality for processing application layer confirmed
services on behalf of connected clients.  For example, it may listen for
unicast confirmed service requests from clients and forward the related unicast
responses to the requesting client without also forwarding it to other clients.

All broadcast messages that are received by the server are forwarded to all
connected clients.

Note that unlike :doc:`lane` the connected clients to a proxy service cannot
exchange packets between themselves, nor are they made aware of the presence
or absence of other connected clients.  Only one connected client provides
BACnet server functionality to the BACnet intranet, responding to Who-Is
requests for example.

Protocol Data Units
-------------------

Packets from the proxy server to the connected clients will have the
SNET/SLEN/SADR fields present.  The DNET/DLEN/DADR fields may also be present
if the packet was broadcast, so the DLEN will always be zero and the DADR
empty.

Packets from a proxy client to its connected server will have the
DNET/DLEN/DADR fields present.

.. _proxy-to-server-unicast-request:

Proxy Client to Server Unicast Request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This packet is sent by a client to the server to request that the server send
the request to a BACnet address on behalf of the client.  The request 
payload is restricted to unicast messages.

The DNET/DLEN/DADR fields of the NPCI will be present, even if the destination
is on the same BACnet network as the proxy server.

.. csv-table:: **Table X.12** Device-to-Device Request Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "Proxy Client to Server Unicast Request (value = X'06')"
   "BSLV Length", "2-octets", "Length"
   "Payload", "variable", "Application PDU"

.. _proxy-to-server-broadcast-request:

Proxy Client to Server Broadcast Request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This packet is sent by a client to the server to request that the server
broadcast the request on the local network in the case of local broadcast
or global broadcast messages, or in the case of a remote network broadcast,
send the request as a unicast message to the router responsible for the
destination network.  The request payload is restricted to broadcast messages.

The DNET/DLEN/DADR fields of the NPCI will be present.  If the destination
is to be considered a local broadcast by the proxy server, then the DNET
will be the network of the proxy server.  In all cases the DLEN will be
zero and the DADR will be the empty octet string.

.. csv-table:: **Table X.13** Device-to-Device Request Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "Proxy Client to Server Broadcast Request (value = X'07')"
   "BSLV Length", "2-octets", "Length"
   "Payload", "variable", "Application PDU"

.. _server-to-proxy-unicast-request:

Proxy Server to Client Unicast Request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This packet is a forwarded copy of a unicast message received by the server
to the client.  The request payload is restricted to unicast messages.

The SNET/SLEN/SADR fields of the NPCI will be present, even if the destination
is on the same BACnet network as the proxy server.  The DNET/DLEN/DADR fields
of the NPCI will be absent.

.. csv-table:: **Table X.14** Device-to-Device Request Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "Proxy Server to Client Unicast Request (value = X'08')"
   "BSLV Length", "2-octets", "Length"
   "Payload", "variable", "Application PDU"

.. _server-to-proxy-broadcast-request:

Proxy Server to Client Broadcast Request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This packet is a forwarded copy of a broadcast message received by the server
to the client.  The request payload is restricted to broadcast messages.

The SNET/SLEN/SADR fields of the NPCI will be present, even if the destination
is on the same BACnet network as the proxy server.

The DNET/DLEN/DADR fields of the NPCI will be present.  If the destination
was a local broadcast when it was received by the proxy server, then the DNET
will be the network of the proxy server.  In all cases the DLEN will be
zero and the DADR will be the empty octet string.

.. csv-table:: **Table X.15** Device-to-Device Request Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "Proxy Server to Client Broadcast Request (value = X'09')"
   "BSLV Length", "2-octets", "Length"
   "Payload", "variable", "Application PDU"
