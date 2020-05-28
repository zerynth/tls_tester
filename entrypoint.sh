#!/bin/sh

CMD=$1
if [ -d "/certs" ]; then
    echo "Custom certs mounted"
    HAS_CUSTOM_CERTS=1
fi



case $CMD in 
    serve)
        if [ -z "$HAS_CUSTOM_CERTS" ]; then
            # no custom certs given
            echo "Serving simple TLS"
            /ssl_server2 debug_level=4
        else
            /ssl_server2 ca_file=/certs/ca.pem crt_file=/certs/server.crt key_file=/certs/server.key debug_level=4
        fi
        ;;
    serve2way)
        if [ -z "$HAS_CUSTOM_CERTS" ]; then
            # no custom certs given
            echo "Serving 2 way auth TLS"
            /ssl_server2 debug_level=4 auth_mode=required
        else
            /ssl_server2 ca_file=/certs/ca.pem crt_file=/certs/server.crt key_file=/certs/server.key debug_level=4 auth_mode=required
        fi
        ;;
    genca)
        if [ -z "$HAS_CUSTOM_CERTS" ]; then
            # no custom certs given
            echo "Please mount /certs directory"
            exit 1
        fi
        echo "Generating Certification Authority private key"
        openssl genrsa -out /certs/ca.key 2048
        echo "Generating Certification Authority"
        openssl req -x509 -new -nodes -key /certs/ca.key -days 7300 -out /certs/ca.pem
        ;;
    gencerts)
        if [ -z "$HAS_CUSTOM_CERTS" ]; then
            # no custom certs given
            echo "Please mount /certs directory"
            exit 1
        fi
        echo "Generating Server private key"
        openssl genrsa -out /certs/server.key 2048
        echo "Generating Server CSR"
        openssl req -new -key /certs/server.key -out /certs/server.csr
        echo "Generating Server Certificate from CSR and CA"
        openssl x509 -req -in /certs/server.csr -CA /certs/ca.pem -CAkey /certs/ca.key -CAcreateserial -out /certs/server.crt -days 500 -sha256
        ;;
    gencli)
        if [ -z "$HAS_CUSTOM_CERTS" ]; then
            # no custom certs given
            echo "Please mount /certs directory"
            exit 1
        fi
        echo "Generating Client private key"
        openssl genrsa -out /certs/client.key 2048
        echo "Generating Client CSR"
        openssl req -new -key /certs/client.key -out /certs/client.csr
        echo "Generating Client Certificate from CSR and CA"
        openssl x509 -req -in /certs/client.csr -CA /certs/ca.pem -CAkey /certs/ca.key -CAcreateserial -out /certs/client.crt -days 500 -sha256
        ;;
    genclifromcsr)
        if [ -z "$HAS_CUSTOM_CERTS" ]; then
            # no custom certs given
            echo "Please mount /certs directory"
            exit 1
        fi
        echo "Generating Client Certificate from CSR and CA"
        openssl x509 -req -in /certs/cclient.csr -CA /certs/ca.pem -CAkey /certs/ca.key -CAcreateserial -out /certs/cclient.crt -days 500 -sha256
        ;;
    *)
        echo "Zerynth TLS tester - available commands:"
        echo "----------------------------------------"
        echo "serve                         - start ssl debug server on port 4433"
        echo "serve2way                     - start ssl debug server on port 4433 requiring 2 way auth"
        echo "genca                         - generate certification authority"
        echo "gencerts                      - generate server certificates"
        echo "gencli                        - generate client certificate and key from CA"
        echo "genclifromcsr                 - generate client certificate from CA given a signed CSR"
        ;;
esac




