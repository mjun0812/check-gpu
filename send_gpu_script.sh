#!/bin/zsh

HOSTS=()
for host in $(cat ./hosts.txt)
do
    if [ ! ${host:0:1} = "#" ]; then
        HOSTS=("${HOSTS[@]}" "$host")
    fi
done

# Get Info throw ssh
eval `ssh-agent` > /dev/null

for i in {1..$#HOSTS}; do
    scp ./gpu_process.sh ${HOSTS[$i]}:~/
    ssh -oStrictHostKeyChecking=no 'chmod +x ~/gpu_process.sh' 2> /dev/null
done

eval `ssh-agent -k` > /dev/null

