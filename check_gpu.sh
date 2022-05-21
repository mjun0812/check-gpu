#!/bin/bash

SCRIPT_HOME=$(dirname $0)

# GPU Info used prettytable.sh.
# It works even if it is not existed,
# but display plain text.
# https://github.com/jakobwesthoff/prettytable.sh
PRETTY_PRINT=0
if [ -e ${SCRIPT_HOME}/prettytable.sh ]; then
    source ${SCRIPT_HOME}/prettytable.sh
    PRETTY_PRINT=1
fi

eval `ssh-agent` > /dev/null

# Commands to ssh server
GPU_CMD="nvidia-smi --query-gpu=index,name,memory.free,memory.used,memory.total --format=csv,noheader"
CPU_CMD="cat /proc/cpuinfo | grep model\ name | uniq"
RAM_CMD="free -g -t | grep Mem"
CMD="${GPU_CMD}; ${CPU_CMD}; ${RAM_CMD}"

# Get target host 
HOST_FILE=${SCRIPT_HOME}/hosts.txt
HOSTS=()
for host in $(cat ${HOST_FILE})
do
    if [ ! ${host:0:1} = "#" ]; then
        HOSTS=("${HOSTS[@]}" "$host")
    fi
done

# Get Info throw ssh
RES=()
for i in "${!HOSTS[@]}"
do
    RES[$i]="$(ssh -oStrictHostKeyChecking=no ${HOSTS[$i]} $CMD &)"
done

# Avobe ssh process is background.
# So, have to wait.
wait

for i in "${!RES[@]}"
do
    # res format string is
    # (GPU INFO)
    # (CPU INFO)
    # (RAM INFO)
    res="${RES[i]}"

    # RAM INFO
    RAM_INFO=$(echo "${res}" | tail -n1 | awk '{print $2}')
    res=$(echo "${res}" | sed '$d')

    # CPU INFO
    CPU_INFO=$(echo "${res}" | tail -n1 | awk -F ":" '{for(i=3;i<NF;++i){printf("%s ",$i)}print $NF}')
    res=$(echo "${res}" | sed '$d')
    
    # GPU INFO
    GPU_INFO='ID\tName\tFree\tUsed\tTotal\n'
    for line in "$(echo "${res}")"
    do
        table=$(echo "${line}" | awk -F "," '{for(i=1;i<NF;++i){printf("%s\t",$i)}print $NF}')
        GPU_INFO="${GPU_INFO}${table}\n"
    done

    # Display Info
    echo -e "\e[34m[${HOSTS[$i]}]\e[m"
    echo -e "\e[34mCPU:\e[m${CPU_INFO}, \e[34mRAM:\e[m ${RAM_INFO}GB"
    if [ $PRETTY_PRINT -eq 1 ]; then
        echo "${GPU_INFO}" | prettytable 5
    else
        echo -e "$GPU_INFO"
    fi
done

eval `ssh-agent -k` > /dev/null

