#update
sudo apt update
sudo apt install cargo -y

#stop and remove db
systemctl stop suid
rm -rf $HOME/.sui/db

#get new  genesis
wget -qO $HOME/.sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob
cd $HOME/sui
git remote add upstream https://github.com/MystenLabs/sui
git fetch upstream
git stash
git checkout -B devnet --track upstream/devnet
cargo build --release
mv $HOME/sui/target/release/{sui,sui-node,sui-faucet} /usr/bin/

#check version
sui -V
#restart
systemctl restart suid
