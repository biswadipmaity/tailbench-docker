#!/bin/bash
# Save perf counters every second

### options
function usage {
	echo >&2 "USAGE: power [-F FILE]"
	exit
}

# Get command line args
while getopts F:h opt
do
	case $opt in
	F)	file=$OPTARG ;;
	h|?)	usage ;;
	esac
done

# If output file not specified, quit
if [ -z "$file" ]
then
      usage
fi


perf stat -I 1000 \
    -a \
    --event=cpu_clk_unhalted.thread,instructions,offcore_requests_outstanding.all_data_rd,cycle_activity.stalls_l3_miss,cycle_activity.stalls_mem_any,offcore_requests.all_requests \
    --output $file