#!/bin/sh

SIGNED_NAME=$(echo $1|sed 's/\.\([a-z0-9]*\)$/_signed.\1/')
ALIGNED_NAME=$(echo $1|sed 's/\.\([a-z0-9]*\)$/_aligned.\1/')
java -jar signapk.jar testkey.x509.pem testkey.pk8 ${1} ${SIGNED_NAME}
export PATH=${PATH}:`pwd`
zipalign -v 4 ${SIGNED_NAME} ${ALIGNED_NAME}
rm ${SIGNED_NAME}
