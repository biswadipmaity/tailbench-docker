#!/bin/bash

BENCH_DIR="src/masstree"

if [ "$load" == "medium" ]
then
    echo "\$load is medium"
    REQS=450000
    QPS=3000
elif [ "$load" == "high" ]
then
    echo "\$load is high"
    REQS=900000
    QPS=6000
else 
    echo "\$load is empty"
    REQS=150000
    QPS=1000
fi

# Change any options before sourcing config
# This runs for about 3 min
##REQS=100000
WARMUP_REQS=14000
source config.sh

time $ssh_cmd "cd $BENCH_DIR; $run_cmd; cd; $parser $BENCH_DIR/lats.bin > ~/lats.txt"
$scp_cmd:lats.txt masstree-lats.txt
