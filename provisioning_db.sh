#!/usr/bin/env bash

set -e

# とりあえず開発ツール関係を入れておく
if ! rpm -qa | grep gcc | grep -v libgcc ; then
    echo "  - yum groupinstall \"Development Tools\""
    sudo yum groupinstall -y "Development Tools"
fi

# 補完してくれるやつ
if ! rpm -qa | grep bash-completion ; then
    echo "  - yum install bash-completion"
    sudo yum install -y bash-completion
fi

# chef インストール
if [ $(rpm -qa | grep chef) ]; then
    echo "  * skip chef install"
else
    echo "  - chef installing"
    curl -L https://www.opscode.com/chef/install.sh | sudo bash
fi

echo ""

# chef 実行(ライセンスへの同意を求められたら yes を入力してください)
# それぞれのファイルはフルパスじゃないとちゃんと動かないようだ・・・
sudo chef-client -z -c /vagrant_data/chef-repo/solo.rb -j /vagrant_data/chef-repo/nodes/mysql_server.json
