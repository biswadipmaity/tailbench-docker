#!/bin/bash

BENCH_DIR="src/moses"

if [ "$load" == "medium" ]
then
    echo "\$load is medium"
    # Runs for 3m 14.531s
    REQS=72000
    QPS=400
elif [ "$load" == "high" ]
then
    echo "\$load is high"
    # Runs for 2m 48.855s
    REQS=108000
    QPS=600
else 
    echo "\$load is low"
    # Runs for 3m 26.710s
    REQS=36000
    QPS=200
fi

# Change any options before sourcing config
# This runs for about 3 min
#REQS=100000
WARMUP_REQS=5000
source config.sh

time $ssh_cmd "cd $BENCH_DIR; $run_cmd; cd; $parser $BENCH_DIR/lats.bin > ~/lats.txt"
$scp_cmd:lats.txt moses-lats.txt
