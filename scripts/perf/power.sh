#!/bin/bash
# Save power every second

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

# If no file, then print on screen
	if [ -z "$file" ]
	then
		echo "Time, Power"
	else
		echo "Time, Power" >> $file
	fi

start_time=$(date +%s.%3N)
while sleep 1;
do 
	power=$(curl -v --silent http://localhost:8110/ 2>&1 | grep -oP 'hs110_power_watt{location="DRG"} \K.*')
	
	end_time=$(date +%s.%3N)
	# elapsed time with millisecond resolution
	# keep three digits after floating point.
	elapsed=$(echo "scale=3; $end_time - $start_time" | bc)

	# If no file, then print on screen
	if [ -z "$file" ]
	then
		echo $elapsed, $power
	else
		echo $elapsed, $power >> $file
	fi
done