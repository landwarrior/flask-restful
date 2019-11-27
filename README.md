# flask-restful

Flask-RESTful を Docker で動かすサンプルを作成するために用意しました。

# 前提条件

- Windows 10 Pro バージョン 1909
- VirtualBox 6.0.14
- Vagrant 2.2.6

# 環境構築手順

1. VirtualBox をインストール
1. Vagrant をインストール
1. vagrant box を追加する
    ```console
    vagrant box add bento/centos-7.7
    ```
1. 任意のディレクトリで、 Vagrant を使用するための準備をする
    ```console
    vagrant init bento/centos-7.7
    ```
1. Vagrantfile を編集する
    - `config.vm.network` のコメントアウトを外す
        - つまり、 `192.168.33.10` でアクセス可能にする
    - `config.vm.synced_folder` のコメントアウトを外し、 `../data` の部分をこのリポジトリを clone した時のルートディレクトリにする
        - つまり、 `/vagrant_data` 配下にマウントしていることが前提
        - 例として、以下のようにする
        ```console
        config.vm.synced_folder "D:/program_src/flask-restful", "/vagrant_data"
        ```
1. Vagrant を立ち上げる
    ```console
    vagrant up
    ```
1. 立ち上がったかどうか確認する
    ```console
    vagrnat global-status
    ```
1. マウントしたディレクトリに移動する
    ```console
    cd /vagrant_data
    ```
1. シェルスクリプトを起動する
    ```console
    sudo su
    ./provisioning.sh
    ```
