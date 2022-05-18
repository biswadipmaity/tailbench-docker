#!/bin/bash

BENCH_DIR="src/shore"

if [ "$load" == "medium" ]
then
    echo "\$load is medium"
    REQS=120000
    QPS=800
elif [ "$load" == "high" ]
then
    echo "\$load is high"
    REQS=240000
    QPS=1600
else 
    echo "\$load is empty"
    REQS=60000
    QPS=400
fi

# Change any options before sourcing config
# This runs for about 3 min
WARMUP_REQS=10000
source config.sh

time $ssh_cmd "cd $BENCH_DIR; $run_cmd; cd; $parser $BENCH_DIR/lats.bin > ~/lats.txt"
$scp_cmd:lats.txt shore-lats.txt
