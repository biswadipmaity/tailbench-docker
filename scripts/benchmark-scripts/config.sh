#!/bin/bash

# Default values that can be overridden by the individual benchmark scripts
RANDSEED=${RANDSEED:-1234}
WARMUP_REQS=${WARMUP_REQS:-1000}
REQS=${REQS:-10000}
QPS=${QPS:-500}
MINSLEEPNS=${MINSLEEPNS:-100000}

TB_DIR="${HOME}/workspace/hpca/tailbench-docker"
UTILS_DIR="src/utilities"
parser="${UTILS_DIR}/parselats.py"

HOSTNAME=${HOSTNAME:-"localhost"}
USERNAME=${USERNAME:-"cc"}

ssh_cmd="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    -i ${TB_DIR}/files/ssh-keys/id_rsa -p 2222 -l $USERNAME $HOSTNAME"

scp_cmd="scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    -i ${TB_DIR}/files/ssh-keys/id_rsa -P 2222 $USERNAME@$HOSTNAME"

run_cmd="\
    RANDSEED=$RANDSEED WARMUPREQS=$WARMUP_REQS REQUESTS=$REQS QPS=$QPS MINSLEEPNS=$MINSLEEPNS \
    ./run.sh"

    #     TBENCH_SERVER=127.0.0.1 \
    # TBENCH_SERVER_PORT=8080 \
    # TBENCH_NCLIENTS=1 \
    # NSERVERS=1 \
    # TBENCH_CLIENT_THREADS=1 \
    # TBENCH_MINSLEEPNS=10000 \
    # TBENCH_RANDSEED=1234 \
