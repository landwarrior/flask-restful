#!/usr/bin/env bash

set -e

# とりあえず開発ツール関係を入れておく
if ! [[ $(rpm -qa | grep gcc | grep -v libgcc) ]]; then
    echo "  - dnf groupinstall \"Development Tools\""
    sudo dnf groupinstall -y "Development Tools"
fi

# 補完してくれるやつ
if ! [[ $(rpm -qa | grep bash-completion) ]]; then
    echo "  - dnf install bash-completion"
    sudo dnf install -y bash-completion
fi

# chef インストール
if [[ $(rpm -qa | grep chef) ]]; then
    echo "  * skip installing chef"
else
    echo "  - chef installing"
    curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chef -v 17.7.29
fi

echo ""

# chef 実行
sudo yes yes | chef-client -z -c /vagrant_data/chef-repo/solo.rb -j /vagrant_data/chef-repo/nodes/mysql_server.json
