#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq git libclang-dev cmake -y
. <(wget -qO- https://raw.githubusercontent.com/MrN1x0n/MrN1x0n/main/rust.sh) -y

mkdir -p $HOME/.sui
git clone https://github.com/MystenLabs/sui
cd sui
git remote add upstream https://github.com/MystenLabs/sui
git fetch upstream
git checkout --track upstream/devnet
cargo build --release
mv $HOME/sui/target/release/{sui,sui-node,sui-faucet} /usr/bin/
cd
wget -qO $HOME/.sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob

cp $HOME/sui/crates/sui-config/data/fullnode-template.yaml \
$HOME/.sui/fullnode.yaml

sed -i -e "s%db-path:.*%db-path: \"$HOME/.sui/db\"%; "\
"s%metrics-address:.*%metrics-address: \"0.0.0.0:9184\"%; "\
"s%json-rpc-address:.*%json-rpc-address: \"0.0.0.0:9000\"%; "\
"s%genesis-file-location:.*%genesis-file-location: \"$HOME/.sui/genesis.blob\"%; " $HOME/.sui/fullnode.yaml

printf "[Unit]
Description=Sui node
After=network-online.target

[Service]
User=$USER
ExecStart=`which sui-node` --config-path $HOME/.sui/fullnode.yaml
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/suid.service

sudo systemctl daemon-reload
sudo systemctl enable suid
sudo systemctl restart suid


. <(wget -qO- https://raw.githubusercontent.com/MrN1x0n/MrN1x0n/main/insert_variable.sh) -n sui_log -v "sudo journalctl -fn 100 -u suid" -a
