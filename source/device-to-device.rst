.. Device-to-Device Service

Device-to-Device Service
========================

The simplest service is a connection between two devices.  There is no 
network layer, so the connection is only used for APDUs.  The NPCI provides
priority, but other fields such as the DNET/DLEN/DADR and SNET/SLEN/SADR are
absent.

After authentication, if the server does not provide the Device-to-Device
Service then it will send a :ref:`service-request-result` with the error code
NO_DEVICE_TO_DEVICE_SERVICE.

Protocol Data Units
-------------------

There is only one kind of packet between the client and server, and once the
session is established, the two end points are peers.

.. _device-to-device-request:

Device-to-Device Request
~~~~~~~~~~~~~~~~~~~~~~~~

This packet is sent by client or the server to its peer.

.. csv-table:: **Table X.10** Device-to-Device Request Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "Device-to-Device Request (value = X'05')"
   "BSLV Length", "2-octets", "Length"
   "Payload", "variable", "Application PDU"
