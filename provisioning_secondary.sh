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

SCRIPT_DIR=$(cd $(dirname $0);pwd)

# chef 実行
sudo echo yes | chef-client -z -c /vagrant_data/chef-repo/solo.rb -j /vagrant_data/chef-repo/nodes/docker_server.json

# ここからは docker 用の準備

echo "  - copy wsgi files for docker"
cp -fr "$SCRIPT_DIR/wsgi" /var/app/docker/flask

echo "  - copy docker files"
cp -fr "$SCRIPT_DIR/docker" /var/app/

echo "  - docker build"
docker build -t flask /var/app/docker/flask/
docker build -t mynginx /var/app/docker/nginx/

# TODO: primary の方で実行する sudo docker swarm join-token worker の内容を手動実行する
# e.g. sudo docker swarm join --token SWMTKN-1-68nxudsy4hq3p1ztiuvzuujzg8l20eur6b7q2k62jitnavd8cn-447u5cqaifqj9iq06o1g3r53f 192.168.33.10:2377
