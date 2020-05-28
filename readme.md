# Zerynth TLS tester

This image bundles together mbedTLS 2.16  SSL server and openssl enabling in depth debugging of TLS connections


## How to use

The image can be used for multiple purposes with run once commands or can sit in background waiting for TLS connections

### Running simple server

```docker run  -p 4433:4433 zerynth/tls_tester```

This will run a TLS server accessible at https://localhost:4433

### Creating certificates

Using some sort of certificates for the TLS server is a good way to better debug connections.
This image provide the following commands (execute in this order to bootstrap)

#### Generate CA

```docker run -v "$PWD"/certs:/certs -it zerynth/tls_tester genca```

Answer all the questions, do not set a password protection

#### Generate Server Certificate and Key

```docker run -v "$PWD"/certs:/certs -it zerynth/tls_tester gencerts```

Answer all the questions, do not set a password protection. When asked for FQDN put "localhost" or your server name (i.e. example.com)

#### Generate Client Certificate and Key

```docker run -v "$PWD"/certs:/certs -it zerynth/tls_tester gencli```

Answer all the questions, do not set a password protection. When asked for FQDN put your client name.

This step is useful for generating client credentials in a two way authentication scheme

#### Generate Client Certificate from CSR

```docker run -v "$PWD"/certs:/certs -it zerynth/tls_tester genclifromcsr```

This step requires the file ```cclient.csr``` to be present in the certs directory. From it a client certificate will be generated
as ```cclient.crt```.
Answer all the questions, do not set a password protection. When asked for FQDN put your client name.

This step is useful for generating client credentials in a two way authentication scheme when the private key of the client is already
existent (i.e. in an HSM or Secure Element).

### Running debug server

```docker run -v "$PWD"/certs:/certs -p 4433:4433 -it zerynth/tls_tester serve```

The server will output detailed debug on standard output.

### Running two way authentication debug server

```docker run -v "$PWD"/certs:/certs -p 4433:4433 -it zerynth/tls_tester serve2way ```

The server will output detailed debug on standard output. It will fail if the client does not provide a client certificate signed
by the server CA.



