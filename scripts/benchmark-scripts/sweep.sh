#!/bin/bash

# Switch to 1-core only
echo "Switching to 1 core operation"
for i in {1..11}; do
    echo 0 > /sys/devices/system/cpu/cpu$i/online
done

echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Disable Turbo
echo 1 | /usr/bin/tee "/sys/devices/system/cpu/intel_pstate/no_turbo"
bash ./run-all.sh no-turbo

# Enable Turbo
echo 0 | /usr/bin/tee "/sys/devices/system/cpu/intel_pstate/no_turbo"
bash ./run-all.sh turbo

# Enale all cores
echo "Switching to 12 core operation"
echo 1| tee /sys/devices/system/cpu/cpu*/online

cat /sys/devices/system/cpu/online

echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor