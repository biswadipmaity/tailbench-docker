#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../configs.sh

THREADS=${THREADS:-1}
REQUESTS=${REQUESTS:-10}
WARMUPREQS=${WARMUPREQS:-10}
QPS=${QPS:-1}

if [ ! -z RANDSEED ] ; then
    export TBENCH_RANDSEED=$RANDSEED
fi

AUDIO_SAMPLES='audio_samples'

LD_LIBRARY_PATH=./sphinx-install/lib:${LD_LIBRARY_PATH} \
    TBENCH_MAXREQS=${REQUESTS} TBENCH_WARMUPREQS=${WARMUPREQS} \
    ./decoder_server_networked -t $THREADS &

echo $! > server.pid

sleep 2

LD_LIBRARY_PATH=./sphinx-install/lib:${LD_LIBRARY_PATH} \
TBENCH_QPS=${QPS} TBENCH_MINSLEEPNS=10000 TBENCH_AN4_CORPUS=${DATA_ROOT}/sphinx \
    TBENCH_AUDIO_SAMPLES=${AUDIO_SAMPLES} ./decoder_client_networked &

echo $! > client.pid

wait $(cat client.pid)

# Cleanup
./kill_networked.sh
rm server.pid client.pid 
