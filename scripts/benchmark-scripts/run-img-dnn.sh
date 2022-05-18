#!/bin/bash

BENCH_DIR="src/img-dnn"

if [ "$load" == "medium" ]
then
    echo "\$load is medium"
    REQS=300000
    QPS=600
elif [ "$load" == "high" ]
then
    echo "\$load is high"
    REQS=500000
    QPS=1000
else 
    echo "\$load is empty"
    REQS=200000
    QPS=400
fi

# Change any options before sourcing config
# This runs for about 3 min
WARMUP_REQS=5000
source config.sh

time $ssh_cmd "cd $BENCH_DIR; $run_cmd; cd; $parser $BENCH_DIR/lats.bin > ~/lats.txt"
$scp_cmd:lats.txt img-dnn-lats.txt
