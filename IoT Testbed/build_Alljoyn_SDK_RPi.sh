#!bin/bash

# build enssential libraries
sudo apt-get install build-essential
sudo apt-get install maven
sudo apt-get install scons
sudo apt-get install git
sudo apt-get install curl
sudo apt-get install openssl
sudo apt-get install libssl-dev
sudo apt-get install libjson0
sudo apt-get install libjson0-dev
sudo apt-get install libcap-dev

# get Alljoyn source from git repos
mkdir ~/bin
echo "export PATH=$PATH:~/bin" >> ~/.bashrc
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
source ~/.bashrc

# PART II
mkdir -p ~/alljoyn_repo/alljoyn
cd ~/alljoyn_repo/alljoyn
git config --global user.name "Rui Tu"
git config --global user.email "ruit@uoregon.edu"
repo init -u https://git.allseenalliance.org/gerrit/devtools/manifest
repo sync
export AJ_ROOT=$(pwd)
sudo ln -s /usr/bin/g++ /usr/bin/arm-angstrom-linux-gnueabi-g++
sudo ln -s /usr/bin/gcc /usr/bin/arm-angstrom-linux-gnueabi-gcc
cd ~/alljoyn_repo/alljoyn/core/alljoyn

# before compilation
sudo apt-get install oracle-java7-jdk
export JAVA_HOME="/usr/lib/jvm/jdk-7-oracle-armhf"
echo "export PATH=$PATH:$JAVA_HOME/bin" >> ~/.bashrc
source ~/.bashrc

# compilation
scons OS=linux CPU=arm WS=off OE_BASE=/usr BR=on BINDINGS=cpp, java  CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-
sudo ln -sf ~/alljoyn_repo/alljoyn/core/alljoyn/build/linux/arm/debug/dist/cpp/lib/liballjoyn.so /lib/arm-linux-gnueabihf/liballjoyn.so

# building additional services
scons OS=linux CPU=arm WS=off SERVICES=about,notification,controlpanel,config,onboarding,sample_apps BINDINGS=core,cpp OE_BASE=/usr CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-

# check if successfully build
cd ~/alljoyn_repo/alljoyn/core/alljoyn/build/linux/arm/debug/dist/cpp/bin
ldd alljoyn-daemon
./alljoyn-daemon --version

# test it out
cd ~/alljoyn_repo/alljoyn/core/alljoyn/build/linux/arm/debug/dist/cpp/bin/samples
./AboutService
