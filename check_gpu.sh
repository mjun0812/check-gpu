#!/bin/zsh

read_parent_dir() {
    local cwd="$(pwd)"
    local target="$1"
    while [ -n "$target" ]; do
        if [ "${target%/*}" != "$target" ]; then
            # $target に含まれる最後の
            # "/" から後ろを削除したパスにcd
            cd "${target%/*}"
        fi
        local name="${target##*/}"
        target="$(readlink "$name" || true)"
    done
    pwd
    cd "$cwd"
}

SCRIPT_HOME="$(read_parent_dir $0)"

# GPU Info used prettytable.sh.
# It works even if it is not existed,
# but display plain text.
# https://github.com/jakobwesthoff/prettytable.sh
PRETTY_PRINT=0
if [ -e ${SCRIPT_HOME}/prettytable.sh ]; then
    source ${SCRIPT_HOME}/prettytable.sh
    PRETTY_PRINT=1
fi


# Commands to ssh server
GPU_CMD="nvidia-smi --query-gpu=index,name,memory.free,memory.used,memory.total --format=csv,noheader"
CPU_CMD="cat /proc/cpuinfo | grep model\ name | uniq"
RAM_CMD="free -g -t | grep Mem"
CMD="${GPU_CMD}; ${CPU_CMD}; ${RAM_CMD};"
# CMD="'${GPU_CMD}; ${CPU_CMD}; ${RAM_CMD}; echo ---;'"

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
eval `ssh-agent` > /dev/null
RES=()
for i in {1..$#HOSTS}
do
    RES[$i]=`ssh -oStrictHostKeyChecking=no ${HOSTS[$i]} $CMD 2> /dev/null &`
done

# # Get Info throw ssh
# eval `ssh-agent` > /dev/null
# ssh-add ~/.ssh/id_rsa
# ALL_RES=`for host in "${HOSTS[@]}"; do echo $host; done | xargs -P 8 -I{} -t bash -c "ssh -A -oStrictHostKeyChecking=no {} $CMD" 2> /dev/null`
# # Split Info par host
# RES=()
# for i in {1..$#HOSTS}
# do
#     local AWK_CMD='{len=split($0, arr, "(^|\\n)---(\\n|$)")}END{print arr['$i']}'
#     RES[$i]=`echo "${ALL_RES}" | awk -vRS='\0' "${AWK_CMD}"`
# done

for i in {1..$#RES}
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

