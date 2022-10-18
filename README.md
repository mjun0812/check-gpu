# Check Remote GPU Server

リモートにある GPU サーバの使用率を確認するスクリプトです．  
同時に CPU と RAM の情報も見ることが出来ます．

This script checks the utilization of remote GPU servers.  
CPU and RAM information can be viewed at the same time.

- example

```bash
[hoge-server]
CPU: AMD EPYC 7452 32-Core Processor, RAM: 1007GB
┌────┬──────────────────────────┬────────────┬────────────┬────────────┐
│ID  │Name                      │Free        │Used        │Total       │
├────┼──────────────────────────┼────────────┼────────────┼────────────┤
│0   │ NVIDIA GeForce RTX 3090  │ 800 MiB    │ 23467 MiB  │ 24576 MiB  │
│1   │ NVIDIA GeForce RTX 3090  │ 800 MiB    │ 23467 MiB  │ 24576 MiB  │
│2   │ NVIDIA GeForce RTX 3090  │ 800 MiB    │ 23467 MiB  │ 24576 MiB  │
│3   │ NVIDIA GeForce RTX 3090  │ 800 MiB    │ 23467 MiB  │ 24576 MiB  │
│4   │ NVIDIA GeForce RTX 3090  │ 800 MiB    │ 23467 MiB  │ 24576 MiB  │
│5   │ NVIDIA GeForce RTX 3090  │ 4534 MiB   │ 19685 MiB  │ 24576 MiB  │
│6   │ NVIDIA GeForce RTX 3090  │ 4534 MiB   │ 19685 MiB  │ 24576 MiB  │
│7   │ NVIDIA GeForce RTX 3090  │ 800 MiB    │ 23467 MiB  │ 24576 MiB  │
└────┴──────────────────────────┴────────────┴────────────┴────────────┘
```

## Usage

まずは，確認したいサーバーの host 名を`host.txt`に書きます．  
1 行ごとにホスト名を書きます．

First, write the host name of the server you wish to check in the `host.txt` file.  
Write the host name on each line.

```bash
touch host.txt
vim host.txt
```

- host.txt

```bash
hoge.local
#fuga
```

`host.txt`は`#`を用いたコメントアウトにも対応しています．  
The `host.txt` file can be commented out using `#`.  

次に，プロセス確認用のスクリプトをサーバーに送信します．  
各サーバーのホームディレクトリにスクリプトが配置されます．  
Next, `gpu_process.sh` script is sent to the servers to confirm the process.  
The script is placed in the home directory of each server.

```bash
./send_gpu_script.sh
```

最後にスクリプト本体を実行します．  
Then, run the script.

```bash
./check_gpu.sh
```

このスクリプトは，シンボリックリンクを再帰的に解決できるので，
PATH が通っている場所にシンボリックリンクを貼れば
どこからでも使えるようになります．

This script can resolve symbolic links recursively.
If you put a symbolic link to a PATH location, you can use it from anywhere.

```bash
ln -s path/to/check_gpu.sh ~/.bin/check-gpu
check-gpu
```

## Info

GPU の表示を綺麗にするために，同梱している
[prettytable.sh](https://github.com/jakobwesthoff/prettytable.sh)
を使っています．

この`prettytable.sh`がない場合でも動作するようにしているので，
スクリプト自体はコピペで使用することが出来ます．

## References

<https://github.com/tmyoda/bash-cluster-smi>

<https://tmyoda.hatenablog.com/entry/20211030/1635587862>
