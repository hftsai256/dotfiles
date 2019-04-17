#!/usr/bin/env bash
# Install docker with Homebrew on OSX
# Reference: https://pilsniak.com/how-to-install-docker-on-mac-os-using-brew/

brew install docker docker-compose docker-machine docker-credential-helper xhyve docker-machine-driver-xhyve

sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve

docker-machine create default --driver xhyve --xhyve-experimental-nfs-share

printf "# Configure docker-machine environment by default\n
eval \"\$(docker-machine env default)\"\n" >> ../scripts/docker.sh