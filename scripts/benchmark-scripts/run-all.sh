#!/bin/bash


TB_DIR="${HOME}/tailbench-docker"

append=""

if [ ! -z "$1" ] 
then
    append="$1"
fi

if [ ! -z "$load" ] 
then
    append="$load/$append"
fi

ts="$append$(date +"%Y-%m-%d-%H-%M-%S")-results"

mkdir -p $ts

run_exp() {
    local script=$1
    local dirname=$2
    local log="${script:6:-2}log"
    load=$load bash -c "$script &> $log" &
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
    pkill -P $(cat power.pid)
    pkill -f power.sh
    # pkill can kill perf in the background
    pkill -P $(cat counter.pid)

    mv $log *-lats.txt $dirname
}

start_time=$(date +%s%N | cut -b1-13)

HOSTNAME=localhost run_exp ./run-xapian.sh $ts
HOSTNAME=localhost run_exp ./run-masstree.sh $ts
HOSTNAME=localhost run_exp ./run-moses.sh $ts
HOSTNAME=localhost run_exp ./run-sphinx.sh $ts
HOSTNAME=localhost run_exp ./run-img-dnn.sh $ts
HOSTNAME=localhost run_exp ./run-silo.sh $ts

# Need to check implementation
# HOSTNAME=localhost run_exp ./run-specjbb.sh $ts
#HOSTNAME=localhost run_exp ./run-shore.sh $ts
end_time=$(date +%s%N | cut -b1-13)

rm -rf *.pid

printf "http://deep.ics.uci.edu:3000/d/hInD3dM7z/node-exporter-full?orgId=1&from=%s&to=%s\n" $start_time $end_time