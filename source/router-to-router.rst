.. Router-to-Router Service

Router-to-Router Service
========================

This service is functionally identical to a PTP connection or Annex H peer
relationship between half-routers.

The DNET/DLEN/DADR and SNET/SLEN/SADR fields are provided for APDU’s.  Network
layer functions, such as the exchange of routing tables, follow the same
procedures and constraints as the PTP functionality in Section X.X.

After authentication, if the server does not provide the Router-to-Router
Service then it will send a :ref:`service-request-result` with the error code
NO_ROUTER_TO_ROUTER_SERVICE.

Protocol Data Units
-------------------

There is only one kind of packet between the client and server, and once the
session is established, the two end points are peers.

.. _router-to-router-request:

Router-to-Router Request
~~~~~~~~~~~~~~~~~~~~~~~~

This packet is sent by client or the server to its peer.

.. csv-table:: **Table X.11** Router-to-Router Request Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "Router-to-Router Request (value = X'06')"
   "BSLV Length", "2-octets", "Length"
   "Payload", "variable", "Application PDU"
