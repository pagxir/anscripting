#!/bin/sh

MYPATH=$(cd `dirname $0`; pwd)
PATH=$PATH:$MYPATH
SIGNED_NAME=$(echo $1|sed 's/\.\([a-z0-9]*\)$/_signed.\1/')
ALIGNED_NAME=$(echo $1|sed 's/\.\([a-z0-9]*\)$/_aligned.\1/')
if echo $ALIGNED_NAME|grep -- -unsigned_aligned.apk; then
ALIGNED_NAME=$(echo $ALIGNED_NAME|sed s/-unsigned_aligned// );
fi;
java -jar ${MYPATH}/signapk.jar $MYPATH/testkey.x509.pem $MYPATH/testkey.pk8 ${1} ${SIGNED_NAME}
export PATH=${PATH}:`pwd`
zipalign -v 4 ${SIGNED_NAME} ${ALIGNED_NAME}
rm ${SIGNED_NAME}
