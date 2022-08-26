#update
sudo apt update
sudo apt install cargo -y

systemctl stop suid

rm -rf /var/sui/db/* /var/sui/genesis.blob $HOME/sui

source $HOME/.cargo/env

cd $HOME

git clone https://github.com/MystenLabs/sui.git

cd sui

git remote add upstream https://github.com/MystenLabs/sui

git fetch upstream

git checkout -B devnet --track upstream/devnet

cargo build -p sui-node -p sui --release

mv ~/sui/target/release/sui-node /usr/local/bin/

mv ~/sui/target/release/sui /usr/local/bin/

wget -qO $HOME/.sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob

#check version
sui -V
#restart
systemctl restart suid
