#!/bin/sh

SIGNED_NAME=$(echo $1|sed 's/\.\([a-z0-9]*\)/_signed.\1/')
java -jar signapk.jar -w testkey.x509.pem testkey.pk8 ${1} ${SIGNED_NAME}
#zipalign -v 4 ${SIGNED_NAME} ${1}
#rm ${SIGNED_NAME}
