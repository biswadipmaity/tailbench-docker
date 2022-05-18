#!/bin/bash

BENCH_DIR="src/xapian"

if [ "$load" == "medium" ]
then
    echo "\$load is medium"
    REQS=160000
    QPS=800
elif [ "$load" == "high" ]
then
    echo "\$load is high"
    REQS=200000
    QPS=1000
else 
    echo "\$load is empty"
    REQS=100000
    QPS=500
fi

# Change any options before sourcing config
# This runs for about 3 min
# REQS=100000
# QPS=500

source config.sh

time $ssh_cmd "cd $BENCH_DIR; $run_cmd; cd; $parser $BENCH_DIR/lats.bin > ~/lats.txt"
$scp_cmd:lats.txt xapian-lats.txt
