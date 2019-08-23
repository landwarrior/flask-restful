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

if [ ! "$(rpm -qa | grep python36u)" ]; then
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

echo "create database if not exists mydb"
mysql -uroot -e"create database if not exists mydb default charset=utf8"
echo "create user myaccount"
mysql -uroot -e"grant all privileges on *.* to myaccount@'%' identified by 'myaccount' with grant option"
echo "create table if not exists users"
mysql -uroot -Dmydb -e"CREATE TABLE IF NOT EXISTS users (
  user_id int(11) NOT NULL,
  user_name varchar(32) NOT NULL,
  group_id int(11) DEFAULT NULL,
  ins_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  upd_date datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8"
echo "create table if not exists groups"
mysql -uroot -Dmydb -e"CREATE TABLE IF NOT EXISTS groups (
  group_id int(11) NOT NULL,
  group_name varchar(32) NOT NULL,
  ins_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  upd_date datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8"
