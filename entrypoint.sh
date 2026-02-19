#!/bin/bash

USER_ID=${LOCAL_UID:-9001}
GROUP_ID=${LOCAL_GID:-9001}
QUIET_MSG=${QUIET_MSG:-FALSE}

if [ "${QUIET_MSG}" = "FALSE" ]; then
  echo "Starting with UID : ${USER_ID}, GID: ${GROUP_ID}"
  getent group ${GROUP_ID} > /dev/null 2>&1 || groupadd -g ${GROUP_ID} worker
  useradd -u ${USER_ID} -g ${GROUP_ID} -o -M -d ${WORK_DIR} worker
else
  getent group ${GROUP_ID} > /dev/null 2>&1 || groupadd -g ${GROUP_ID} worker > /dev/null 2>&1
  useradd -u ${USER_ID} -g ${GROUP_ID} -o -M -d ${WORK_DIR} worker > /dev/null 2>&1
fi
export HOME=/work

chown ${USER_ID}:${GROUP_ID} ${WORK_DIR}

exec /usr/sbin/gosu worker "$@"
