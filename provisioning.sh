#!/usr/bin/env bash

set -e

# とりあえずアップデートしておく
echo "yum update"
sudo yum update -y

echo ""

# とりあえず開発ツール関係を入れておく
echo "yum groupinstall \"Development Tools\""
sudo yum groupinstall -y "Development Tools"

# chef インストール
if [ $(rpm -qa | grep chef) ]; then
    echo "skip chef install"
else
    echo "chef installing"
    curl -L https://www.opscode.com/chef/install.sh | sudo bash
fi

echo ""

if [ ! "$(rpm -qa | grep python3)" ]; then
    # Python3系のリポジトリを追加する
    echo "add ius repo"
    yum install -y https://centos7.iuscommunity.org/ius-release.rpm
    echo "install python36"
    yum install -y python36u python36u-libs python36u-devel python36u-pip
    echo "upgrade pip"
    pip3.6 install --upgrade pip
    echo "install flask-restful (include flask)"
    pip3.6 install flask-restful
    echo "install flask-sqlalchemy"
    pip3.6 install flask-sqlalchemy
fi

# chef 実行(ライセンスへの同意を求められたら yes を入力してください)
# それぞれのファイルはフルパスじゃないとちゃんと動かないようだ・・・
sudo chef-solo -c /vagrant_data/chef-repo/solo.rb -j /vagrant_data/chef-repo/nodes/flask-restful.json
