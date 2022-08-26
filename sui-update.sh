sudo apt update
sudo apt install cargo
systemctl stop suid
rm -rf $HOME/.sui/db
wget -qO $HOME/.sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob
cd $HOME/sui
git remote add upstream https://github.com/MystenLabs/sui
git fetch upstream
git stash
git checkout -B devnet --track upstream/devnet
cargo build --release
mv $HOME/sui/target/release/{sui,sui-node,sui-faucet} /usr/bin/
