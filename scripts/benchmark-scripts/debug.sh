#!/bin/bash

# echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# for load in high
# do
#     load=$load bash ./run-all.sh tmp-
# done    

# echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
# http://deep.ics.uci.edu:3000/d/hInD3dM7z/node-exporter-full?orgId=1&from=1649712769548&to=1649712929103


{ 
    read cycles_idle 
} < <(python3 getPromtheusData.py --start 1649712769548 --end 1649712929103 --query 'sum by (instance) (rate(node_cpu_seconds_total{mode="idle"}[15s])) * 100')

{ 
    read cycles_user
} < <(python3 getPromtheusData.py --start 1649712769548 --end 1649712929103 --query 'sum by (instance) (rate(node_cpu_seconds_total{mode="user"}[15s])) * 100')

{ 
    read cycles_others
} < <(python3 getPromtheusData.py --start 1649712769548 --end 1649712929103 --query 'sum by (instance) (rate(node_cpu_seconds_total{mode!="idle",mode!="user"}[15s])) * 100')

echo $cycles_idle, $cycles_user, $cycles_others