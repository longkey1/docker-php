#!/bin/bash

USER_ID=${LOCAL_UID:-9001}
GROUP_ID=${LOCAL_GID:-9001}

echo "Starting with UID : ${USER_ID}, GID: ${GROUP_ID}"
useradd -u ${USER_ID} -o -d ${WORK_DIR} worker
groupmod -g ${GROUP_ID} worker
export HOME=/work

chown worker:worker ${WORK_DIR}

exec /usr/sbin/gosu worker "$@"
