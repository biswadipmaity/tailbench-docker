#!/bin/bash

BENCH_DIR="src/sphinx"


if [ "$load" == "medium" ]
then
    echo "\$load is medium"
    REQS=150
    QPS=1
elif [ "$load" == "high" ]
then
    echo "\$load is high"
    REQS=180
    QPS=1.2
else 
    echo "\$load is empty"
    REQS=120
    QPS=0.8
fi

# Change any options before sourcing config
# This runs for about 3 min
# REQS=150
# QPS=1
WARMUP_REQS=10
source config.sh

time $ssh_cmd "cd $BENCH_DIR; $run_cmd; cd; $parser $BENCH_DIR/lats.bin > ~/lats.txt"
$scp_cmd:lats.txt sphinx-lats.txt
