# Check Remote CUDA Server

リモートにある GPU サーバの使用率を確認するスクリプトです．  
同時に CPU と RAM の情報も見ることが出来ます．

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

`host.txt`を書いたら，スクリプト本体を実行します．

```bash
./check_gpu.sh
```

## Info

GPU の表示を綺麗にするために，同梱している
[prettytable.sh](https://github.com/jakobwesthoff/prettytable.sh)
を使っています．

この`prettytable.sh`がない場合でも動作するようにしているので，
スクリプト自体はコピペで使用することが出来ます．
