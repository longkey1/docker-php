#!/bin/bash

USER_ID=${LOCAL_UID:-9001}
GROUP_ID=${LOCAL_GID:-9001}

echo "Starting with UID : $USER_ID, GID: $GROUP_ID"
mkdir -p /work
useradd -u $USER_ID -o -d /work worker
groupmod -g $GROUP_ID worker
export HOME=/work

chown worker:worker /work

exec /usr/sbin/gosu worker "$@"
