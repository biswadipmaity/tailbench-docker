#!/bin/bash

TB_DIR="${HOME}/workspace/hpca/tailbench-docker"

ts="$(date +"%Y-%m-%d-%H-%M-%S")-results"
mkdir -p $ts

run_exp() {
    local script=$1
    local dirname=$2
    local log="${script:6:-2}log"
    $script &> $log &
    local app="${script:6:-3}"
    
    echo $! > $app.pid
    echo $app" started"

    # Measure power
    $TB_DIR/scripts/perf/power.sh -F $dirname/$app-power.log &
    echo $! > power.pid

    # Measure counters
    $TB_DIR/scripts/perf/counters.sh -F $dirname/$app-counter.log &
    echo $! > counter.pid

    wait $(cat $app.pid)

    # Kill instrumentation scripts
    kill -9 $(cat power.pid)
    # pkill can kill perf in the background
    pkill -P $(cat counter.pid)

    mv $log *-lats.txt $dirname
}

HOSTNAME=localhost run_exp ./run-xapian.sh $ts
HOSTNAME=localhost run_exp ./run-masstree.sh $ts
HOSTNAME=localhost run_exp ./run-moses.sh $ts
HOSTNAME=localhost run_exp ./run-sphinx.sh $ts
HOSTNAME=localhost run_exp ./run-img-dnn.sh $ts
# HOSTNAME=localhost run_exp ./run-specjbb.sh $ts
HOSTNAME=localhost run_exp ./run-silo.sh $ts
#HOSTNAME=localhost run_exp ./run-shore.sh $ts

rm -rf *.pid
