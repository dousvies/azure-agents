#!/bin/bash
# safer bash scripts - makes it similar to high level programming languages scripts
# see https://explainshell.com/explain?cmd=set+-euxo+pipefail
set -x          # print each command before executing it
set -e          # exit immediately when a command fails
set -u          # unset variables throw an error and exit immediately
set -o pipefail # exit code of a pipeline is set to that of the rightmost command to exit with a non-zero status

export DEBIAN_FRONTEND=noninteractive

# install os dependencies
apt-get update
apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg git gpw
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs) && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list
apt-get update
apt-get -y install azure-cli

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt-get update
apt-get -y install docker-ce

# download agent files
mkdir -p /home/ubuntu/agent-config && cd /home/ubuntu/agent-config
wget https://vstsagentpackage.azureedge.net/agent/2.193.1/vsts-agent-linux-x64-2.193.1.tar.gz
tar zxf vsts-agent-linux-x64-2.193.1.tar.gz

# install agent dependencies
chmod +x bin/installdependencies.sh
/bin/bash bin/installdependencies.sh

/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync