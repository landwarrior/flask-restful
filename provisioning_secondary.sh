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

SCRIPT_DIR=$(cd $(dirname $0);pwd)

if  ! rpm -qa | grep python3 ; then
    # Python3系のリポジトリを追加する
    echo "  - add ius repo"
    yum install -y https://centos7.iuscommunity.org/ius-release.rpm
    echo "  - install python3"
    yum install -y python3 python3-libs python3-devel python3-pip
    echo "  - install python modules"
    pip3.6 install -r "$SCRIPT_DIR/docker/flask/requirements.txt"
else
    echo "  * skip installing python3"
fi

echo ""

# chef 実行(ライセンスへの同意を求められたら yes を入力してください)
# それぞれのファイルはフルパスじゃないとちゃんと動かないようだ・・・
sudo chef-client -z -c /vagrant_data/chef-repo/solo.rb -j /vagrant_data/chef-repo/nodes/docker_server.json

# ここからは docker 用の準備

echo "  - copy wsgi files for docker"
cp -fr "$SCRIPT_DIR/wsgi" /var/app/docker/flask

echo "  - copy docker files"
cp -fr "$SCRIPT_DIR/docker" /var/app/

echo "  - docker build"
docker build -t flask /var/app/docker/flask/
docker build -t mynginx /var/app/docker/nginx/

# primary の方で以下のコマンドを実行して docker swarm join するコマンドを得る
# docker swarm join-token worker
