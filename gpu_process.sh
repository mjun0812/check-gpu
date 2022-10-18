#!/bin/zsh

INFO=$(nvidia-smi pmon -c 1 -s m)
TABLE=$(echo $INFO | tail -n +3 | awk -F" " 'BEGIN{OFS = "\t"}{if($4 > 200){printf("%d\t%d\t%5dMB\n", $1, $2, $4)}}')
PIDS=$(echo $INFO | tail -n +3 | awk -F" " '{if($4 > 200){print $2}}')

PS_AUX=$(ps au)
if [ "${PIDS}" = "found" ]; then
    TABLE="\t \t \n"
else
    for pid in $(echo ${PIDS}); do
        user=$(echo "${PS_AUX}" | grep -a $pid | head -n 1 | awk '{print $1}')
        TABLE=$(echo "${TABLE}" | sed -e "s/${pid}/${user}/g")
    done
fi

echo $TABLE

