#!/bin/bash

BENCH_DIR="src/silo"

# Change any options before sourcing config
# This runs for about 3 min
if [ "$load" == "medium" ]
then
    echo "\$load is medium"
    REQS=700000
    QPS=4000
elif [ "$load" == "high" ]
then
    echo "\$load is high"
    REQS=1400000
    QPS=8000
else 
    echo "\$load is empty"
    REQS=350000
    QPS=2000
fi

echo $QPS
WARMUP_REQS=20000
source config.sh

time $ssh_cmd "cd $BENCH_DIR; $run_cmd; cd; $parser $BENCH_DIR/lats.bin > ~/lats.txt"
$scp_cmd:lats.txt silo-lats.txt
 