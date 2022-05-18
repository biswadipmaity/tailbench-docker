#!/bin/bash

# Enale all cores
echo "Switching to 12 core operation"
echo 1| tee /sys/devices/system/cpu/cpu*/online

# Enable Turbo
echo 0 | /usr/bin/tee "/sys/devices/system/cpu/intel_pstate/no_turbo"

echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# for pstate in {16..100..2}
# do
#     echo $pstate > /sys/devices/system/cpu/intel_pstate/max_perf_pct
#     sleep 1
#     bash ./run-all.sh pstate-noTurbo-$pstate
# done

# for load in low medium high
# do
#     load=$load bash ./run-all.sh load-$load
# done

for pstate in {16..100..2}
do
    echo $pstate > /sys/devices/system/cpu/intel_pstate/max_perf_pct
    sleep 1
    for load in low medium high
    do
        load=$load bash ./run-all.sh pstate-$pstate-
    done    
done


# echo "3800000" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
# bash ./run-all.sh 3800

# echo "4200000" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
# bash ./run-all.sh 4200

# echo "4500000" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
# bash ./run-all.sh 4500

# echo "4900000" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
# bash ./run-all.sh 4900

echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor