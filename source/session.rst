.. Session Layer

Sessions
========

A :term:`session` is an agreement between the :term:`client` that initiated the
connection and the :term:`server` that accepted it to use the connection in
a specific way.  It assumes that the details of establishing and maintaining
the connection have already been provided by a
:term:`connection-oriented protocol`.

*Authentication* is the process of determining the identity of a connected
client by a server.  The authentication procedure described in this section is
optional, the server may already have determined the identity of the client
as a consequence of establishing a secure connection, or the server may
provide the service to all clients.  Determining when authentication is
necessary is a local matter.

*Authorization* is the process of validating the right to a service by an
authenticated client.  Authorization is a local matter.

Service Procedure
-----------------

Clients request a service by sending a :ref:`service-request` to the server
using the appropriate :ref:`service-identifier`.  The service responds with
an appropriate :ref:`service-request-result`.

If the server responds with AUTHENTICATION_REQUIRED then the client will
send an :ref:`access-request` with its user name.  The server will respond
with :ref:`access-challenge` to authenticate the user, and the client will
respond with an :ref:`access-response` to the challenge.  If the challenge is
successful, the server will respond with a :ref:`service-request-result` with
the result code SUCCESS.

Protocol Data Units
-------------------

The session PDUs are used to request a specific type of session and establish
authentication.  Authorization is a function of the server.  Authentication
is not necessary if the mechanism used to establish the connection already
provides authentication, or if the service allows for "guest" access.

.. _service-request:

Service Request
~~~~~~~~~~~~~~~

This PDU is sent by a client to a server to request that the connection by used
for a specific service.  The server may provide more than one service via a
common connection endpoint.

.. csv-table:: **Table X.2** Service Request Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "BSLV Result (value = X'00')"
   "BSLV Length", "2-octets", "Length (value = X'0006')"
   "Service Identifier", "2-octets", ":ref:`service-identifier`"

.. _service-identifier:

Service Identifier
''''''''''''''''''

Service identifiers are used to identify a service.

.. csv-table:: **Table X.3** Service Identifiers
   :header: "Service Identifier Code", "Value", "Description"
   :widths: 20, 5, 30

   "DEVICE_TO_DEVICE_SERVICE_ID", 1, ":doc:`device-to-device`"
   "ROUTER_TO_ROUTER_SERVICE_ID", 2, ":doc:`router-to-router`"
   "PROXY_SERVICE_ID", 3, ":doc:`proxy`"
   "LANE_SERVICE_ID", 4, ":doc:`lane`"

.. _service-request-result:

Service Request Result
~~~~~~~~~~~~~~~~~~~~~~

This PDU is used by the server to acknowledge that the service
requested by the client is accepted and established, or to signal an error
condition.

.. csv-table:: **Table X.4** Service Request Result Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "BSLV Result (value = X'00')"
   "BSLV Length", "2-octets", "Length (value = X'0006')"
   "Result Code", "2-octets", "Success (value = X'0000') or error"

Result Codes
''''''''''''

If the server cannot provide the service requested, or the client is not
authorized to use the service, the server may respond with a BSLL Response
with function code X'00' and one of the following error values.  It will
then terminate the connection.

.. csv-table:: **Table X.5** Result Codes
   :header: "Result Code", "Value", "Description"
   :widths: 20, 5, 30

   "SUCCESS", 0
   "NO_DEVICE_TO_DEVICE_SERVICE", 1
   "NO_ROUTER_TO_ROUTER_SERVICE", 2
   "NO_PROXY_SERVICE", 3
   "NO_LANE_SERVICE", 4
   "UNRECOGNIZED_SERVICE", 10
   "AUTHENTICATION_REQUIRED", 11, "Authentication required"
   "AUTHENTICATION_FAILURE", 12, "Username and/or username/password failure"
   "AUTHENTICATION_NO_SERVICE", 13, ""
   "AUTHENTICATION_HASH", 14, "Specified hash function not supported"

.. _access-request:

Access Request
~~~~~~~~~~~~~~

This PDU is sent by a client to the server to initiate the authentication
process.  It may be sent before a :ref:`service-request` when the client
knows *a priory* that authentication will be required, or when told by the
server it is necessary.

This request includes a request to use a :term:`cryptographic hash function`
to provide a level of encryption of the subsequent :ref:`access-challenge` and
:ref:`access-response` PDUs.

.. csv-table:: **Table X.6** Access Request Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "Access Request (value = X'02')"
   "BSLV Length", "2-octets", "Length (variable)"
   "Hash Function Identifier", "1-octet", ":ref:`hash-function-identifier`"
   "User name", "variable", "User name"

The user name is an octet string that identifies the client within the context
understood by the server.

.. note::

   I expect the user name to morph into the public key of a
   public/private key pair, rather than using usernames and passwords.

If the server does not support the hash function requested by the client, the
server will respond with a :ref:`service-request-result` with the error code
AUTHENTICATION_HASH and close the connection.

If the server does not recognize the user name provided by the client it may
continue with the authentication process by sending an :ref:`access-challenge`
which will ultimately fail, it may send a :ref:`service-request-result` with
the error code AUTHENTICATION_FAILURE and close the connection, or simply close
the connection.

.. _hash-function-identifier:

Hash Function Identifier
''''''''''''''''''''''''

The hash function identifier specifies which function of a number of functions
that both the client and server will use to create digest values contained in
the :ref:`access-challenge` and :ref:`access-response` PDUs.

.. csv-table:: **Table X.7** Hash Function Identifiers
   :header: "Hash Function Identifier Code", "Value", "Description"
   :widths: 20, 5, 30

   "MD5", 0, "`MD5 <https://en.wikipedia.org/wiki/MD5>`_ **obsolete**"
   "SHA-1", 1, "`SHA-1 <https://en.wikipedia.org/wiki/SHA-1>`_ **obsolete**"
   "SHA-2, 224", 2, "`SHA-2 <https://en.wikipedia.org/wiki/SHA-2>`_"
   "SHA-2, 256", 3, ""
   "SHA-2, 384", 4, ""
   "SHA-2, 512", 5, ""

.. _access-challenge:

Access Challenge
~~~~~~~~~~~~~~~~

This PDU is sent by a server to a client after it receives an
:ref:`access-request` to request that the client confirm the user name it
presented to the server.

.. csv-table:: **Table X.8** Access Challenge Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "Access Request (value = X'02')"
   "BSLV Length", "2-octets", "Length (variable)"
   "Hash Function Identifier", "1-octet", ":ref:`hash-function-identifier`"
   "Challenge Data", "variable", "Challenge data"

The hash function identifier matches the value requested by the client in the
:ref:`access-request`.

The challenge data is a suitably large block of random data.

.. _access-response:

Access Response
~~~~~~~~~~~~~~~

This PDU is sent by the client after receiving a :ref:`access-challenge`
from the server.

.. csv-table:: **Table X.9** Access Response Format
   :header: "Field", "Size", "Description"
   :widths: 10, 8, 30

   "BSLV Type", "1-octet", "Streaming BACnet (value = X'82')"
   "BSLV Function", "1-octet", "Access Response (value = X'03')"
   "BSLV Length", "2-octets", "Length (variable)"
   "Hash Function Identifier", "1-octet", ":ref:`hash-function-identifier`"
   "Response Digest", "variable", "Response digest"

The hash function identifier matches the value requested by the client in the
:ref:`access-request` and provided by the sever in the :ref:`access-challenge`.

The response digest is the cryptographic digest of the secret password stored
by the client concatenated with the challenge data provided by the server.

.. note::

   I expect the password to morph into the private key of a
   public/private key pair, rather than using usernames and passwords.

When the server receives the access response, it performs the identical
calculation as the client by computing the cryptographic digest of the secret
password associated with the client concatenated with the challenge data it
provided earlier.  If the calculation results are identical, the client is
considered authenticated.

If the server does not recognize the user name provided by the client it may
continue with the authentication process by sending an :ref:`access-challenge`
which will ultimately fail, it may send a :ref:`service-request-result` with
the error code AUTHENTICATION_FAILURE and close the connection, or simply close
the connection.

If the authenticated client had previously requested a specific service, the
server will verify that the client is authorized to access the service.  If
the client is authorized, the server will respond with a
:ref:`service-request-result` with the error code SUCCESS.  If the client is
not authorized, the server will respond with a :ref:`service-request-result`
with the error code AUTHENTICATION_NO_SERVICE and closes the connection.
