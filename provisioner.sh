#!/bin/bash
# safer bash scripts - makes it similar to high level programming languages scripts
# see https://explainshell.com/explain?cmd=set+-euxo+pipefail
set -e          # exit immediately when a command fails
set -u          # unset variables throw an error and exit immediately
set -x          # print each command before executing it
set -o pipefail # exit code of a pipeline is set to that of the rightmost command to exit with a non-zero status

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs) && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
apt-get update
apt-get -y install azure-cli
/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync