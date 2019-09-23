#!/usr/bin/env bash

set -e

# とりあえずアップデートしておく
echo "  - yum update"
sudo yum update -y

echo ""

# とりあえず開発ツール関係を入れておく
echo "  - yum groupinstall \"Development Tools\""
sudo yum groupinstall -y "Development Tools"

# chef インストール
if [ $(rpm -qa | grep chef) ]; then
    echo "  * skip chef install"
else
    echo "  - chef installing"
    curl -L https://www.opscode.com/chef/install.sh | sudo bash
fi

echo ""

SCRIPT_DIR=$(cd $(dirname $0);pwd)

if [ ! "$(rpm -qa | grep python3)" ]; then
    # Python3系のリポジトリを追加する
    echo "  - add ius repo"
    yum install -y https://centos7.iuscommunity.org/ius-release.rpm
    echo "  - install python36"
    yum install -y python36u python36u-libs python36u-devel python36u-pip
    echo "  - pip install"
    pip3.6 install -r "$SCRIPT_DIR/docker/flask/requirements.txt"
else
    echo "  * skip installing python3"
fi

echo ""

# chef 実行(ライセンスへの同意を求められたら yes を入力してください)
# それぞれのファイルはフルパスじゃないとちゃんと動かないようだ・・・
sudo chef-solo -c /vagrant_data/chef-repo/solo.rb -j /vagrant_data/chef-repo/nodes/flask-restful.json

# ここからは docker 用の準備

echo "  - copy wsgi files for docker"
cp -fr "$SCRIPT_DIR/wsgi" /var/app/docker/flask

echo "  - copy docker files"
cp -fr "$SCRIPT_DIR/docker" /var/app/

echo "  - docker build"
docker build -t flask /var/app/docker/flask
docker build -t nginx /var/app/docker/nginx

echo "  - docker swarm init"
docker swarm init --advertise-addr 192.168.33.10
