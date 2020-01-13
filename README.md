# flask-restful

Flask-RESTful を Docker で動かすサンプルを作成するために用意しました。
Docker Swarm での構築のサンプルのため、 VM は合計 3 台必要です。

- flask-primary
- flask-secondary
- mysq-server

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
    - 合計 3 台分用意してください。
    ```console
    vagrant init bento/centos-7.7
    ```
1. Vagrantfile を編集する
    - `config.vm.network` のコメントアウトを外す
        - primary は `192.168.33.10` でアクセス可能にする
        - secondary は `192.168.33.11` でアクセス可能にする
        - mysql-server は `192.168.33.20` でアクセス可能にする
    - `config.vm.network` の下に、 `config.vm.hostname` を追加する（必須ではありません）
        - `192.168.33.10` の場合、 `config.vm.hostname = "flask-primary"`
        - `192.168.33.11` の場合、 `config.vm.hostname = "flask-secondary"`
        - `192.168.33.20` の場合、 `config.vm.hostname = "mysql-server"`
    - `config.vm.synced_folder` のコメントアウトを外し、 `../data` の部分をこのリポジトリを clone した時のルートディレクトリにする
        - つまり、 `/vagrant_data` 配下にマウントしていることが前提
        - 例として、以下のように設定する
        ```console
        config.vm.synced_folder "D:/program_src/flask-restful", "/vagrant_data"
        ```
1. Vagrant を立ち上げる（3台とも）
    ```console
    vagrant up
    ```
1. 立ち上がったかどうか確認する
    ```console
    vagrnat global-status
    ```
1. VM にログインし、シェルスクリプトを起動する
    - flask-primary の場合、以下
    ```console
    sudo /vagrant_data/provisioning_primary.sh
    ```
    - flask-secondary の場合、以下
    ```console
    sudo /vagrant_data/provisioning_secondary.sh
    ```
    - mysql-server の場合、以下
    ```console
    sudo /vagrant_data/provisioning_db.sh
    ```
